import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/supabase_client.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/auth/presentation/login_screen.dart';
import 'package:psold/features/auth/presentation/register_choice_screen.dart';
import 'package:psold/features/auth/presentation/register_merchant_screen.dart';
import 'package:psold/features/auth/presentation/register_client_screen.dart';
import 'package:psold/features/auth/presentation/onboarding_screen.dart';
import 'package:psold/features/feed/presentation/feed_screen.dart';
import 'package:psold/features/upload/presentation/upload_screen.dart';
import 'package:psold/features/product/presentation/product_detail_screen.dart';
import 'package:psold/features/merchant/presentation/merchant_dashboard_screen.dart';
import 'package:psold/features/merchant/presentation/merchant_products_screen.dart';
import 'package:psold/features/notifications/presentation/notifications_screen.dart';
import 'package:psold/features/settings/presentation/settings_screen.dart';
import 'package:psold/features/settings/presentation/profile_screen.dart';
import 'package:psold/features/search/presentation/search_screen.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => PsoldSupabaseClient.instance.client);

final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserProfile?>((ref) {
  return CurrentUserNotifier(ref);
});

class UserProfile {
  final String id;
  final String role;
  final String? displayName;
  final String? whatsapp;
  final String? avatarUrl;
  final String? city;

  const UserProfile({
    required this.id,
    required this.role,
    this.displayName,
    this.whatsapp,
    this.avatarUrl,
    this.city,
  });

  bool get isMerchant => role == 'merchant';
  bool get isClient => role == 'client';

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      role: map['role'] as String,
      displayName: map['display_name'] as String?,
      whatsapp: map['whatsapp'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      city: map['city'] as String?,
    );
  }
}

class CurrentUserNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(null) {
    _init();
  }

  void _init() {
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        final session = authState.session;
        if (session != null) {
          _loadProfile(session.user.id);
        } else {
          state = null;
        }
      });
    }, fireImmediately: true);
  }

  Future<void> _loadProfile(String userId) async {
    final supabase = ref.read(supabaseClientProvider);
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response != null) {
      state = UserProfile.fromMap(Map<String, dynamic>.from(response));
    }
  }

  Future<void> signOut() async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.signOut();
    state = null;
  }
}

class _NavScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const _NavScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    final isMerchant = profile?.isMerchant ?? false;
    final merchantDestinations = const [
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
    ];
    final clientDestinations = const [
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
    ];

    void onDestinationSelected(int index) {
      if (isMerchant) {
        switch (index) {
          case 0: navigationShell.goBranch(0); break;
          case 1: navigationShell.goBranch(1); break;
          case 2: navigationShell.goBranch(2); break;
          case 3: navigationShell.goBranch(3); break;
          case 4: navigationShell.goBranch(4); break;
        }
      } else {
        switch (index) {
          case 0: navigationShell.goBranch(0); break;
          case 1: navigationShell.goBranch(1); break;
          case 2: navigationShell.goBranch(2); break;
          case 3: navigationShell.goBranch(3); break;
        }
      }
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: PsoldColors.backgroundLight,
        indicatorColor: PsoldColors.navBarActiveIndicator,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: isMerchant ? merchantDestinations : clientDestinations,
      ),
    );
  }
}

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);

    final authState = container.read(authStateProvider);
    final profile = container.read(currentUserProvider);

    final isLoading = authState.isLoading;
    final session = authState.valueOrNull?.session;
    final isLoggedIn = session != null;

    final isAuthRoute = state.fullPath == '/login' ||
        state.fullPath == '/register' ||
        state.fullPath == '/onboarding';

    if (isLoading) return null;

    if (!isLoggedIn && !isAuthRoute) return '/login';
    if (isLoggedIn && isAuthRoute && profile == null) return '/onboarding';
    if (isLoggedIn && isAuthRoute && profile != null) return '/feed';

    if (profile != null) {
      if (state.fullPath == '/upload' && !profile.isMerchant) return '/feed';
      if (state.fullPath?.startsWith('/merchant') == true && !profile.isMerchant) return '/feed';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterChoiceScreen(),
      routes: [
        GoRoute(
          path: 'merchant',
          name: 'registerMerchant',
          builder: (context, state) => const RegisterMerchantScreen(),
        ),
        GoRoute(
          path: 'client',
          name: 'registerClient',
          builder: (context, state) => const RegisterClientScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => _NavScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/feed',
              name: 'feed',
              builder: (context, state) => const FeedScreenWrapper(),
              routes: [
                GoRoute(
                  path: 'favorites',
                  name: 'favorites',
                  builder: (context, state) => const _FavoritesPlaceholder(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/upload',
              name: 'upload',
              builder: (context, state) => const UploadScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/merchant/products',
              name: 'merchantProducts',
              builder: (context, state) => const MerchantProductsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      name: 'productDetail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/merchant/dashboard',
      name: 'merchantDashboard',
      builder: (context, state) => const MerchantDashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);

class FeedScreenWrapper extends ConsumerWidget {
  const FeedScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    if (profile == null) return const FeedScreen(isMerchant: false);
    return FeedScreen(isMerchant: profile.isMerchant);
  }
}

class _FavoritesPlaceholder extends StatelessWidget {
  const _FavoritesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aucun favori',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Les produits que vous likerez apparaîtront ici',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/feed'),
              child: const Text('Retour au feed'),
            ),
          ],
        ),
      ),
    );
  }
}
