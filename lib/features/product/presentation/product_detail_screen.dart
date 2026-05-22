import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _commentController = TextEditingController();
  int _currentImageIndex = 0;
  bool _isLiked = false;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productAsync = ref.read(productDetailProvider(widget.productId));
      productAsync.whenData((product) {
        if (product.videoUrl != null) {
          _initializeVideo(product.videoUrl!);
        }
      });
    });
  }

  Future<void> _initializeVideo(String url) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await _videoController!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _isPlaying = false;
        });
      }
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final commentsAsync = ref.watch(productCommentsProvider(widget.productId));
    final profile = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      body: productAsync.when(
        data: (product) => _buildProductContent(context, product, commentsAsync, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, Product product, AsyncValue<List<Comment>> commentsAsync, UserProfile? profile) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: PsoldColors.backgroundLight,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMediaGallery(product),
            ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(PsoldSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriceSection(context, product),
                const SizedBox(height: PsoldSpacing.md),
                _buildProductInfo(context, product),
                const SizedBox(height: PsoldSpacing.md),
                _buildLikeSection(context, product),
                const Divider(height: 32),
                if (profile?.isClient == true && profile?.whatsapp != null) ...[
                  _buildMerchantContact(context, product),
                  const Divider(height: 32),
                ],
                Text(
                  AppLocalizations.of(context)!.comments,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: PsoldSpacing.md),
                _buildCommentInput(context),
                const SizedBox(height: PsoldSpacing.md),
                commentsAsync.when(
                  data: (comments) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) => _buildCommentItem(context, comments[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur: $e'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaGallery(Product product) {
    final hasVideo = product.videoUrl != null;
    final mediaCount = product.images.length + (hasVideo ? 1 : 0);
    final totalItems = mediaCount > 0 ? mediaCount : 1;

    return Stack(
      children: [
        PageView.builder(
          itemCount: totalItems,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemBuilder: (context, index) {
            if (hasVideo && index == 0) {
              return _buildVideoPlayer();
            }
            final imageIndex = hasVideo ? index - 1 : index;
            if (product.images.isEmpty || imageIndex >= product.images.length) {
              return Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 64));
            }
            return CachedNetworkImage(
              imageUrl: product.images[imageIndex],
              memCacheWidth: MediaQuery.of(context).size.width.toInt(),
              memCacheHeight: 300,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 64),
              ),
            );
          },
        ),
        if (totalItems > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalItems,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isVideoInitialized || _videoController == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
                _isPlaying = !_isPlaying;
              });
            },
            child: AnimatedOpacity(
              opacity: _isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black26,
                child: const Center(
                  child: Icon(Icons.play_circle_filled, size: 72, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        if (_isPlaying)
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: VideoProgressIndicator(
              _videoController!,
              allowScrubbing: true,
              colors: const VideoProgressColors(playedColor: PsoldColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (product.priceOriginal != null) ...[
          Text(
            '${product.priceOriginal!.toInt()} CFA',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
          ),
          const SizedBox(width: PsoldSpacing.sm),
        ],
        Text(
          '${product.pricePromo.toInt()} CFA',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: PsoldColors.primary, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
          decoration: BoxDecoration(
            color: product.daysUntilExpiry <= 7
                ? Colors.red
                : product.daysUntilExpiry <= 30
                    ? Colors.orange
                    : const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.daysUntilExpiry <= 0 ? 'Expiré' : '${product.daysUntilExpiry} jour(s) restant(s)',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (product.description != null) ...[
          const SizedBox(height: PsoldSpacing.sm),
          Text(product.description!, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: PsoldSpacing.md),
        Wrap(
          spacing: PsoldSpacing.sm,
          children: [
            _InfoChip(icon: Icons.category, label: _getCategoryLabel(product.category)),
            if (product.city != null) _InfoChip(icon: Icons.location_on, label: product.city!),
            _InfoChip(icon: Icons.inventory_2, label: 'Qté: ${product.quantity}'),
          ],
        ),
      ],
    );
  }

  Widget _buildLikeSection(BuildContext context, Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            setState(() => _isLiked = !_isLiked);
            await ref.read(likeToggleProvider(product.id))();
          },
          child: Row(
            children: [
              Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : Colors.grey, size: 28),
              const SizedBox(width: PsoldSpacing.xs),
              Text(
                '${_isLiked ? product.likesCount + 1 : product.likesCount} likes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantContact(BuildContext context, Product product) {
    final phone = product.merchantWhatsapp ?? '+236000000';
    final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final message = Uri.encodeComponent(
            'Bonjour, je suis intéressé par votre produit "${product.title}" publié sur Psold. Est-il encore disponible ?',
          );
          final url = Uri.parse('https://wa.me/$cleanPhone?text=$message');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.chat_rounded),
        label: Text(AppLocalizations.of(context)!.discuss, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: PsoldColors.whatsapp,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Ajouter un commentaire...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
            ),
          ),
        ),
        const SizedBox(width: PsoldSpacing.sm),
        IconButton(
          onPressed: () async {
            if (_commentController.text.isNotEmpty) {
              await ref.read(addCommentProvider(widget.productId))(_commentController.text);
              _commentController.clear();
            }
          },
          icon: const Icon(Icons.send, color: PsoldColors.primary),
        ),
      ],
    );
  }

  Widget _buildCommentItem(BuildContext context, Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: PsoldSpacing.md),
      padding: const EdgeInsets.all(PsoldSpacing.md),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 20)),
              const SizedBox(width: PsoldSpacing.sm),
              Text(comment.userName ?? 'Anonyme', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: PsoldSpacing.xs),
          Text(comment.content),
        ],
      ),
    );
  }

  String _getCategoryLabel(String cat) {
    switch (cat) {
      case 'alimentaire': return 'Alimentaire';
      case 'cosmetique': return 'Cosmétique';
      case 'electronique': return 'Électronique';
      case 'autre': return 'Autre';
      default: return cat;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: PsoldSpacing.xs),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}