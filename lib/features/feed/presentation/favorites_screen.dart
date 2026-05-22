import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';

part 'favorites_screen.g.dart';

@riverpod
Future<List<Product>> favorites(Ref ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];

  final response = await supabase
      .from('likes')
      .select('products(*, profiles(display_name, whatsapp))')
      .eq('user_id', userId);

  final likes = response as List<dynamic>;
  return likes
      .map((like) {
        final productMap = like['products'] as Map<String, dynamic>?;
        if (productMap == null) return null;
        return Product.fromMap(Map<String, dynamic>.from(productMap));
      })
      .whereType<Product>()
      .toList();
}

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: favoritesAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: PsoldSpacing.md),
                  Text(
                    'Aucun favori',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: PsoldSpacing.sm),
                  Text(
                    'Les produits que vous likerez apparaîtront ici',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(PsoldSpacing.md),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _FavoriteCard(product: product);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: PsoldSpacing.md),
              Text('Erreur: $e'),
              const SizedBox(height: PsoldSpacing.md),
              ElevatedButton(
                onPressed: () => ref.invalidate(favoritesProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  final Product product;

  const _FavoriteCard({required this.product});

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
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
                          memCacheWidth: 360,
                          memCacheHeight: 180,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 48),
                          ),
                        )
                      : Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 48),
                        ),
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
                Positioned(
                  top: PsoldSpacing.sm,
                  right: PsoldSpacing.sm,
                  child: GestureDetector(
                    onTap: () async {
                      await ref.read(likeToggleProvider(product.id))();
                      ref.invalidate(favoritesProvider);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red, size: 24),
                    ),
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
                  if (product.city != null) ...[
                    const SizedBox(height: PsoldSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          product.city!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: PsoldSpacing.sm),
                  Row(
                    children: [
                      if (product.priceOriginal != null) ...[
                        Text(
                          '${product.priceOriginal!.toInt()} CFA',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: PsoldSpacing.sm),
                      ],
                      Text(
                        '${product.pricePromo.toInt()} CFA',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: PsoldColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
