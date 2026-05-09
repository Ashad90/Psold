import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';

final selectedNavIndexProvider = StateProvider.family<int, bool>((ref, isMerchant) {
  return 0;
});

class PsoldScaffold extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const PsoldScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    final isMerchant = profile?.isMerchant ?? false;
    final selectedIndex = _getSelectedIndex(currentPath, isMerchant);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onNavTap(context, index, isMerchant),
        backgroundColor: PsoldColors.backgroundLight,
        indicatorColor: PsoldColors.navBarActiveIndicator,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: isMerchant
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Accueil',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle_rounded),
                  label: 'Publier',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Mes produits',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications_rounded),
                  label: 'Alertes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Paramètres',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Accueil',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_outline),
                  selectedIcon: Icon(Icons.favorite_rounded),
                  label: 'Favoris',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications_rounded),
                  label: 'Alertes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Paramètres',
                ),
              ],
      ),
    );
  }

  int _getSelectedIndex(String path, bool isMerchant) {
    if (path.startsWith('/feed')) return 0;
    if (path.startsWith('/upload')) return 1;
    if (path.startsWith('/merchant')) return 2;
    if (path.startsWith('/notifications')) return isMerchant ? 3 : 2;
    if (path.startsWith('/settings') || path.startsWith('/profile')) return isMerchant ? 4 : 3;
    return 0;
  }

  void _onNavTap(BuildContext context, int index, bool isMerchant) {
    final routes = isMerchant
        ? ['/feed', '/upload', '/merchant/products', '/notifications', '/settings']
        : ['/feed', '/favorites', '/notifications', '/settings'];

    final target = routes[index];
    if (target != '/favorites') {
      context.go(target);
    }
  }
}

class PsoldShell extends ConsumerWidget {
  final Widget child;
  final GoRouterState state;

  const PsoldShell({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PsoldScaffold(
      currentPath: state.fullPath ?? '/feed',
      child: child,
    );
  }
}