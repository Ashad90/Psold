// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'1e19cd159690a8c114ba44df8f224a54f95caffa';

/// See also [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider =
    AutoDisposeProvider<NotificationService>.internal(
      notificationService,
      name: r'notificationServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationServiceRef = AutoDisposeProviderRef<NotificationService>;
String _$fcmTokenHash() => r'abdd923a27d33b185b171610fb6bab0aa6fc7398';

/// See also [fcmToken].
@ProviderFor(fcmToken)
final fcmTokenProvider = AutoDisposeFutureProvider<String?>.internal(
  fcmToken,
  name: r'fcmTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fcmTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmTokenRef = AutoDisposeFutureProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
