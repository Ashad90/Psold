import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/merchant/domain/merchant_provider.dart';

class MerchantProductsScreen extends ConsumerStatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  ConsumerState<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends ConsumerState<MerchantProductsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(merchantProductsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(merchantProductsProvider);
    final currentStatus = ref.watch(merchantProductStatusProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes Produits'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(merchantProductsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusFilter(currentStatus),
          Expanded(
            child: _buildBody(productsState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/upload'),
        icon: const Icon(Icons.add),
        label: const Text('Publier'),
        backgroundColor: PsoldColors.primary,
      ),
    );
  }

  Widget _buildStatusFilter(MerchantProductStatus currentStatus) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
      child: Row(
        children: MerchantProductStatus.values.map((status) {
          final isSelected = status == currentStatus;
          return Padding(
            padding: const EdgeInsets.only(right: PsoldSpacing.sm),
            child: FilterChip(
              label: Text(_getStatusLabel(status)),
              selected: isSelected,
              onSelected: (_) {
                ref.read(merchantProductStatusProvider.notifier).state = status;
                ref.read(merchantProductsProvider.notifier).refresh();
              },
              selectedColor: _getStatusColor(status).withValues(alpha: 0.2),
              checkmarkColor: _getStatusColor(status),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getStatusLabel(MerchantProductStatus status) {
    switch (status) {
      case MerchantProductStatus.all: return 'Tous';
      case MerchantProductStatus.active: return 'Actifs';
      case MerchantProductStatus.pending: return 'En attente';
      case MerchantProductStatus.rejected: return 'Refusés';
    }
  }

  Color _getStatusColor(MerchantProductStatus status) {
    switch (status) {
      case MerchantProductStatus.all: return PsoldColors.primary;
      case MerchantProductStatus.active: return Colors.green;
      case MerchantProductStatus.pending: return Colors.amber;
      case MerchantProductStatus.rejected: return Colors.red;
    }
  }

  Widget _buildBody(MerchantProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: PsoldSpacing.md),
            Text('Erreur: ${state.error}'),
            TextButton(
              onPressed: () => ref.read(merchantProductsProvider.notifier).refresh(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: PsoldSpacing.md),
            Text(
              'Aucun produit dans cette catégorie',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: PsoldSpacing.md),
            ElevatedButton.icon(
              onPressed: () => context.go('/upload'),
              icon: const Icon(Icons.add),
              label: const Text('Publier un produit'),
              style: ElevatedButton.styleFrom(backgroundColor: PsoldColors.primary, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(merchantProductsProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(PsoldSpacing.md),
        itemCount: state.products.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: PsoldSpacing.lg),
              child: Center(
                child: state.isLoadingMore
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const SizedBox.shrink(),
              ),
            );
          }
          return _MerchantProductCard(product: state.products[index]);
        },
      ),
    );
  }
}

class _MerchantProductCard extends ConsumerWidget {
  final MerchantProduct product;

  const _MerchantProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor();
    final statusLabel = _getStatusLabel();

    return Container(
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
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(height: 160, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
                        errorWidget: (_, __, ___) => Container(height: 160, color: Colors.grey[200], child: const Icon(Icons.image, size: 48)),
                      )
                    : Container(height: 160, color: Colors.grey[200], child: const Icon(Icons.image, size: 48)),
              ),
              Positioned(
                top: PsoldSpacing.sm,
                left: PsoldSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: PsoldSpacing.xs),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                top: PsoldSpacing.sm,
                right: PsoldSpacing.sm,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(PsoldSpacing.xs),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                    child: const Icon(Icons.more_vert, size: 20),
                  ),
                  onSelected: (value) => _handleAction(context, ref, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('Voir le produit')),
                    const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                    if (product.validated)
                      const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(PsoldSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: PsoldSpacing.xs),
                Row(
                  children: [
                    if (product.priceOriginal != null) ...[
                      Text(
                        '${product.priceOriginal!.toInt()} CFA',
                        style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[500], fontSize: 13),
                      ),
                      const SizedBox(width: PsoldSpacing.xs),
                    ],
                    Text(
                      '${product.pricePromo.toInt()} CFA',
                      style: const TextStyle(color: PsoldColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: PsoldSpacing.sm),
                Row(
                  children: [
                    _InfoChip(icon: Icons.visibility, label: '${product.viewsCount}'),
                    const SizedBox(width: PsoldSpacing.sm),
                    _InfoChip(icon: Icons.favorite, label: '${product.likesCount}'),
                    const SizedBox(width: PsoldSpacing.sm),
                    _InfoChip(
                      icon: Icons.schedule,
                      label: product.daysUntilExpiry <= 0 ? 'Expiré' : '${product.daysUntilExpiry}j',
                      color: product.daysUntilExpiry <= 7 ? Colors.red : product.daysUntilExpiry <= 30 ? Colors.orange : Colors.green,
                    ),
                  ],
                ),
                if (product.rejectionReason != null) ...[
                  const SizedBox(height: PsoldSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(PsoldSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, size: 16, color: Colors.red[700]),
                        const SizedBox(width: PsoldSpacing.xs),
                        Expanded(
                          child: Text(
                            product.rejectionReason!,
                            style: TextStyle(color: Colors.red[700], fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!product.validated) {
      return product.rejectionReason != null ? Colors.red : Colors.amber;
    }
    return Colors.green;
  }

  String _getStatusLabel() {
    if (!product.validated) {
      return product.rejectionReason != null ? 'Refusé' : 'En attente';
    }
    return 'Actif';
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'view':
        context.go('/product/${product.id}');
        break;
      case 'edit':
        context.go('/merchant/products/edit/${product.id}');
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer le produit?'),
            content: Text('Voulez-vous vraiment supprimer "${product.title}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await ref.read(merchantProductDeleteProvider(product.id))();
        }
        break;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: PsoldSpacing.xs),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color ?? Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}