// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userLocationHash() => r'e2e83f993483e88d35eb98641569026a03897357';

/// See also [userLocation].
@ProviderFor(userLocation)
final userLocationProvider =
    AutoDisposeProvider<({double? lat, double? lng})>.internal(
      userLocation,
      name: r'userLocationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userLocationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserLocationRef = AutoDisposeProviderRef<({double? lat, double? lng})>;
String _$isBackgroundLocationEnabledHash() =>
    r'cd5b487d7dbd2f97c7c8f943ad2981549da0d928';

/// See also [isBackgroundLocationEnabled].
@ProviderFor(isBackgroundLocationEnabled)
final isBackgroundLocationEnabledProvider = AutoDisposeProvider<bool>.internal(
  isBackgroundLocationEnabled,
  name: r'isBackgroundLocationEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isBackgroundLocationEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsBackgroundLocationEnabledRef = AutoDisposeProviderRef<bool>;
String _$locationHash() => r'59f8d8cbacfee6c6be77c462faa17e5d46a9d0fa';

/// See also [Location].
@ProviderFor(Location)
final locationProvider =
    AutoDisposeNotifierProvider<Location, LocationState>.internal(
      Location.new,
      name: r'locationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Location = AutoDisposeNotifier<LocationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
