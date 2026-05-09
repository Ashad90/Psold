import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';
import 'package:psold/shared/utils/location_service.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends ConsumerStatefulWidget {
  final bool isMerchant;

  const FeedScreen({super.key, required this.isMerchant});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.listen(feedFilterProvider, (_, __) {
      ref.read(feedProductsProvider.notifier).refresh();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationState = ref.read(locationProvider);
      if (!locationState.hasLocation && !locationState.isLoading && !locationState.permissionDenied) {
        ref.read(locationProvider.notifier).getCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(feedProductsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProductsProvider);
    final filter = ref.watch(feedFilterProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Produits en solde'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(context, ref, filter),
          Expanded(
            child: _buildBody(feedState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(FeedState feedState) {
    if (feedState.isLoading && feedState.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feedState.error != null && feedState.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: PsoldSpacing.md),
            Text('Erreur: ${feedState.error}'),
            const SizedBox(height: PsoldSpacing.md),
            ElevatedButton(
              onPressed: () => ref.read(feedProductsProvider.notifier).refresh(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (feedState.products.isEmpty) {
      return const Center(child: Text('Aucun produit disponible'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(feedProductsProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(PsoldSpacing.md),
        itemCount: feedState.products.length + (feedState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= feedState.products.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: PsoldSpacing.lg),
              child: Center(
                child: feedState.isLoadingMore
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const SizedBox.shrink(),
              ),
            );
          }
          return ProductCard(product: feedState.products[index]);
        },
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context, WidgetRef ref, FeedFilter filter) {
    final categories = ['Tous', 'alimentaire', 'cosmetique', 'electronique', 'autre'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
      child: Row(
        children: categories.map((cat) {
          final isSelected = (cat == 'Tous' && filter.category == null) || filter.category == cat;
          return Padding(
            padding: const EdgeInsets.only(right: PsoldSpacing.sm),
            child: FilterChip(
              label: Text(cat == 'Tous' ? 'Tous' : _getCategoryLabel(cat)),
              selected: isSelected,
              onSelected: (_) {
                ref.read(feedFilterProvider.notifier).state = filter.copyWith(category: cat == 'Tous' ? null : cat);
                ref.read(feedProductsProvider.notifier).refresh();
              },
              selectedColor: PsoldColors.primary.withValues(alpha: 0.2),
              checkmarkColor: PsoldColors.primary,
            ),
          );
        }).toList(),
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

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(context: context, builder: (context) => const _FilterSheet());
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(feedFilterProvider);

    return Container(
      padding: const EdgeInsets.all(PsoldSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtres', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: PsoldSpacing.lg),
          Text('Trier par', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: PsoldSpacing.sm),
          Wrap(
            spacing: PsoldSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Date péremption'),
                selected: filter.sortBy == 'expiry',
                onSelected: (_) {
                  ref.read(feedFilterProvider.notifier).state = filter.copyWith(sortBy: 'expiry');
                  ref.read(feedProductsProvider.notifier).refresh();
                },
              ),
              ChoiceChip(
                label: const Text('Popularité'),
                selected: filter.sortBy == 'popularity',
                onSelected: (_) {
                  ref.read(feedFilterProvider.notifier).state = filter.copyWith(sortBy: 'popularity');
                  ref.read(feedProductsProvider.notifier).refresh();
                },
              ),
            ],
          ),
          const SizedBox(height: PsoldSpacing.lg),
          Text('Rayon (km)', style: Theme.of(context).textTheme.titleSmall),
          Slider(
            value: filter.radiusKm ?? 10,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${filter.radiusKm?.toInt() ?? 10} km',
            onChanged: (value) => ref.read(feedFilterProvider.notifier).state = filter.copyWith(radiusKm: value),
          ),
          const SizedBox(height: PsoldSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: PsoldColors.primary, foregroundColor: Colors.white),
              child: const Text('Appliquer'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = product.daysUntilExpiry;
    final badgeColor = daysLeft <= 7
        ? Colors.red
        : daysLeft <= 30
            ? Colors.orange
            : const Color(0xFF2E7D32);

    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: PsoldSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(height: 180, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
                          errorWidget: (_, __, ___) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image, size: 48)),
                        )
                      : Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image, size: 48)),
                ),
                Positioned(
                  top: PsoldSpacing.sm,
                  left: PsoldSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: PsoldSpacing.xs),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      daysLeft <= 0 ? 'Expiré' : '$daysLeft jour${daysLeft > 1 ? 's' : ''}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
                if (product.quantity <= 5)
                  Positioned(
                    top: PsoldSpacing.sm,
                    right: PsoldSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: PsoldSpacing.xs),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                      child: Text('Qté: ${product.quantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(PsoldSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (product.city != null) ...[
                    const SizedBox(height: PsoldSpacing.xs),
                    Row(children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(product.city!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    ]),
                  ],
                  const SizedBox(height: PsoldSpacing.sm),
                  Row(
                    children: [
                      if (product.priceOriginal != null) ...[
                        Text(
                          '${product.priceOriginal!.toInt()} CFA',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
                        ),
                        const SizedBox(width: PsoldSpacing.sm),
                      ],
                      Text(
                        '${product.pricePromo.toInt()} CFA',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PsoldColors.primary, fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      Row(children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('${product.likesCount}'),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}