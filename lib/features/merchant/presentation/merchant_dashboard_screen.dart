import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:psold/features/merchant/domain/merchant_provider.dart';

class MerchantDashboardScreen extends ConsumerWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    final stats = ref.watch(merchantStatsProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mon Dashboard'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(merchantStatsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(merchantStatsProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(PsoldSpacing.md),
          children: [
            Text(
              'Bienvenue, ${profile?.displayName ?? 'Marchand'}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: PsoldSpacing.lg),
            if (stats.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (stats.error != null)
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: PsoldSpacing.md),
                    Text('Erreur: ${stats.error}'),
                    TextButton(
                      onPressed: () => ref.read(merchantStatsProvider.notifier).refresh(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              )
            else ...[
              _UploadLimitCard(profile: profile),
              const SizedBox(height: PsoldSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Produits actifs',
                      value: '${stats.activeProducts}',
                      icon: Icons.inventory_2,
                      color: PsoldColors.primary,
                    ),
                  ),
                  const SizedBox(width: PsoldSpacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Vues totales',
                      value: '${stats.totalViews}',
                      icon: Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PsoldSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Likes',
                      value: '${stats.totalLikes}',
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: PsoldSpacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Expirent soon',
                      value: '${stats.expiringProducts}',
                      icon: Icons.warning,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PsoldSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'En attente',
                      value: '${stats.pendingProducts}',
                      icon: Icons.hourglass_empty,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: PsoldSpacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Refusés',
                      value: '${stats.rejectedProducts}',
                      icon: Icons.cancel,
                      color: Colors.red[700]!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PsoldSpacing.lg),
              Text(
                'Actions rapides',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: PsoldSpacing.sm),
              _ActionTile(
                icon: Icons.add_photo_alternate,
                title: 'Publier un produit',
                subtitle: 'Ajouter un nouveau produit',
                onTap: () => context.go('/upload'),
              ),
              _ActionTile(
                icon: Icons.list_alt,
                title: 'Mes produits',
                subtitle: 'Gérer mes publications',
                onTap: () => context.go('/merchant/products'),
              ),
              _ActionTile(
                icon: Icons.analytics,
                title: 'Statistiques',
                subtitle: 'Voir les performances',
                onTap: () => context.go('/merchant/stats'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UploadLimitCard extends ConsumerWidget {
  final UserProfile? profile;

  const _UploadLimitCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (profile == null) return const SizedBox.shrink();
    final isPremium = profile!.isPremium;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PsoldSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPremium
            ? const LinearGradient(colors: [Color(0xFFFF6B2B), Color(0xFFFFA726)])
            : null,
        color: isPremium ? null : Colors.white,
        boxShadow: isPremium
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(PsoldSpacing.sm),
            decoration: BoxDecoration(
              color: isPremium ? Colors.white.withValues(alpha: 0.2) : PsoldColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPremium ? Icons.workspace_premium_rounded : Icons.cloud_upload_rounded,
              color: isPremium ? Colors.white : PsoldColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: PsoldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPremium ? 'Premium' : 'Limite quotidienne',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isPremium ? Colors.white : null,
                  ),
                ),
                Text(
                  isPremium
                      ? 'Illimité'
                      : '${profile!.remainingImages} images · ${profile!.remainingVideos} vidéos',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isPremium ? Colors.white.withValues(alpha: 0.8) : PsoldColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('ACTIF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
            )
          else
            GestureDetector(
              onTap: () => context.push('/premium'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
                decoration: BoxDecoration(
                  color: PsoldColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Premium',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PsoldSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: PsoldSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: PsoldSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: PsoldColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}