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
import 'package:psold/features/auth/presentation/google_profile_setup_screen.dart';
import 'package:psold/features/feed/presentation/feed_screen.dart';
import 'package:psold/features/feed/presentation/favorites_screen.dart';
import 'package:psold/features/upload/presentation/upload_screen.dart';
import 'package:psold/features/product/presentation/product_detail_screen.dart';
import 'package:psold/features/merchant/presentation/merchant_dashboard_screen.dart';
import 'package:psold/features/merchant/presentation/merchant_products_screen.dart';
import 'package:psold/features/notifications/presentation/notifications_screen.dart';
import 'package:psold/features/settings/presentation/settings_screen.dart';
import 'package:psold/features/settings/presentation/profile_screen.dart';
import 'package:psold/features/search/presentation/search_screen.dart';
import 'package:psold/shared/utils/location_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => PsoldSupabaseClient.instance.client);

final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserProfile?>((ref) {
  return CurrentUserNotifier(ref);
});

final merchantBackgroundLocationProvider = Provider<void>((ref) {
  ref.listen<UserProfile?>(currentUserProvider, (previous, next) {
    final locationNotifier = ref.read(locationProvider.notifier);
    if (next != null && next.isMerchant) {
      locationNotifier.startBackgroundTracking();
    } else {
      locationNotifier.stopBackgroundTracking();
    }
  });
});

class UserProfile {
  final String id;
  final String role;
  final String? displayName;
  final String? whatsapp;
  final String? avatarUrl;
  final String? city;
  final DateTime? lastActive;

  const UserProfile({
    required this.id,
    required this.role,
    this.displayName,
    this.whatsapp,
    this.avatarUrl,
    this.city,
    this.lastActive,
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
      lastActive: map['last_active'] != null ? DateTime.parse(map['last_active'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'display_name': displayName,
      'whatsapp': whatsapp,
      'avatar_url': avatarUrl,
      'city': city,
      'last_active': lastActive?.toIso8601String(),
    };
  }
}

class CurrentUserNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(null) {
    _init();
  }

  void _init() {
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) async {
        final session = authState.session;
        if (session != null) {
          await _loadProfile(session.user.id);
          await _updateLastActive();
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

  Future<void> _updateLastActive() async {
    if (state == null) return;
    final supabase = ref.read(supabaseClientProvider);
    await supabase
        .from('profiles')
        .update({'last_active': DateTime.now().toIso8601String()})
        .eq('id', state!.id);
    state = UserProfile(
      id: state!.id,
      role: state!.role,
      displayName: state!.displayName,
      whatsapp: state!.whatsapp,
      avatarUrl: state!.avatarUrl,
      city: state!.city,
      lastActive: DateTime.now(),
    );
  }

  bool shouldAutoLogout() {
    if (state?.lastActive == null) return false;
    final fiveDaysAgo = DateTime.now().subtract(const Duration(days: 5));
    return state!.lastActive!.isBefore(fiveDaysAgo);
  }

  Future<void> signOut() async {
    final supabase = ref.read(supabaseClientProvider);
    state = null;
    await supabase.auth.signOut();
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
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Accueil'),
      NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle_rounded), label: 'Publier'),
      NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'Mes produits'),
      NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications_rounded), label: 'Alertes'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Paramètres'),
    ];
    final clientDestinations = const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Accueil'),
      NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite_rounded), label: 'Favoris'),
      NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications_rounded), label: 'Alertes'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Paramètres'),
    ];

    void onDestinationSelected(int index) {
      navigationShell.goBranch(index);
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

class _RoleAwareBranch extends ConsumerWidget {
  final Widget merchantScreen;
  final Widget clientScreen;

  const _RoleAwareBranch({required this.merchantScreen, required this.clientScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    return profile?.isMerchant == true ? merchantScreen : clientScreen;
  }
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}

final _authRefreshNotifier = _AuthRefreshNotifier();

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    try {
      final container = ProviderScope.containerOf(context);

      final authState = container.read(authStateProvider);
      final profile = container.read(currentUserProvider);

      final isLoading = authState.isLoading;
      final session = authState.valueOrNull?.session;
      final isLoggedIn = session != null;
      final isGoogleUser = session?.user.appMetadata['provider'] == 'google';

      final isAuthRoute = state.fullPath == '/login' ||
          state.fullPath == '/register' ||
          state.fullPath == '/register/merchant' ||
          state.fullPath == '/register/client';

      if (isLoading) return null;

      if (!isLoggedIn && !isAuthRoute) return '/login';

      if (isLoggedIn && profile != null) {
        final notifier = container.read(currentUserProvider.notifier);
        if (notifier.shouldAutoLogout()) {
          notifier.signOut();
          return '/login';
        }
        if (isAuthRoute) return '/feed';
        return null;
      }

      if (isLoggedIn && profile == null && isGoogleUser) {
        return '/google-profile-setup';
      }

      if (isLoggedIn && profile == null) return '/onboarding';
    } catch (e) {
      debugPrint('Router redirect error: $e');
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
    GoRoute(
      path: '/google-profile-setup',
      name: 'googleProfileSetup',
      builder: (context, state) => const GoogleProfileSetupScreen(),
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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/branch1',
              name: 'branch1',
              builder: (context, state) => const _RoleAwareBranch(
                merchantScreen: UploadScreen(),
                clientScreen: FavoritesScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/branch2',
              name: 'branch2',
              builder: (context, state) => const _RoleAwareBranch(
                merchantScreen: MerchantProductsScreen(),
                clientScreen: NotificationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/branch3',
              name: 'branch3',
              builder: (context, state) => const _RoleAwareBranch(
                merchantScreen: NotificationsScreen(),
                clientScreen: SettingsScreen(),
              ),
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
