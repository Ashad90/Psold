// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'a4c1216422b0833d80426c94e37c2ed29e0df827';

/// See also [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$authStateHash() => r'e697aa3ef2eec5065468eb2b29d003ed687fb6d5';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<AuthState>;
String _$merchantBackgroundLocationHash() =>
    r'ccdba9be9f33ddbac020ddf998f01157f5459f17';

/// See also [merchantBackgroundLocation].
@ProviderFor(merchantBackgroundLocation)
final merchantBackgroundLocationProvider = AutoDisposeProvider<void>.internal(
  merchantBackgroundLocation,
  name: r'merchantBackgroundLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$merchantBackgroundLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantBackgroundLocationRef = AutoDisposeProviderRef<void>;
String _$currentUserHash() => r'a889ba48a53777ed646d2ba3eefb1c46f6b70f97';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeNotifierProvider<CurrentUser, UserProfile?>.internal(
      CurrentUser.new,
      name: r'currentUserProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentUserHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentUser = AutoDisposeNotifier<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
