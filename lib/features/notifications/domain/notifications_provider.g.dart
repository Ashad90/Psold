// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsHash() => r'be48b311505b7dd5e79c73b9839fce0bcc8c06f3';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeFutureProvider<List<AppNotification>>.internal(
      notifications,
      name: r'notificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsRef = AutoDisposeFutureProviderRef<List<AppNotification>>;
String _$unreadNotificationsCountHash() =>
    r'0cc985ca598829dff68240a58f6e4bccb81647f3';

/// See also [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider =
    AutoDisposeFutureProvider<int>.internal(
      unreadNotificationsCount,
      name: r'unreadNotificationsCountProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$unreadNotificationsCountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationsCountRef = AutoDisposeFutureProviderRef<int>;
String _$markNotificationReadHash() =>
    r'ee9819c8fdd3a29e5e89e9affd9f99f586b3fd5f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [markNotificationRead].
@ProviderFor(markNotificationRead)
const markNotificationReadProvider = MarkNotificationReadFamily();

/// See also [markNotificationRead].
class MarkNotificationReadFamily extends Family<Future<void> Function()> {
  /// See also [markNotificationRead].
  const MarkNotificationReadFamily();

  /// See also [markNotificationRead].
  MarkNotificationReadProvider call(String notificationId) {
    return MarkNotificationReadProvider(notificationId);
  }

  @override
  MarkNotificationReadProvider getProviderOverride(
    covariant MarkNotificationReadProvider provider,
  ) {
    return call(provider.notificationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'markNotificationReadProvider';
}

/// See also [markNotificationRead].
class MarkNotificationReadProvider
    extends AutoDisposeProvider<Future<void> Function()> {
  /// See also [markNotificationRead].
  MarkNotificationReadProvider(String notificationId)
    : this._internal(
        (ref) => markNotificationRead(
          ref as MarkNotificationReadRef,
          notificationId,
        ),
        from: markNotificationReadProvider,
        name: r'markNotificationReadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$markNotificationReadHash,
        dependencies: MarkNotificationReadFamily._dependencies,
        allTransitiveDependencies:
            MarkNotificationReadFamily._allTransitiveDependencies,
        notificationId: notificationId,
      );

  MarkNotificationReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notificationId,
  }) : super.internal();

  final String notificationId;

  @override
  Override overrideWith(
    Future<void> Function() Function(MarkNotificationReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarkNotificationReadProvider._internal(
        (ref) => create(ref as MarkNotificationReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notificationId: notificationId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Future<void> Function()> createElement() {
    return _MarkNotificationReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarkNotificationReadProvider &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notificationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarkNotificationReadRef
    on AutoDisposeProviderRef<Future<void> Function()> {
  /// The parameter `notificationId` of this provider.
  String get notificationId;
}

class _MarkNotificationReadProviderElement
    extends AutoDisposeProviderElement<Future<void> Function()>
    with MarkNotificationReadRef {
  _MarkNotificationReadProviderElement(super.provider);

  @override
  String get notificationId =>
      (origin as MarkNotificationReadProvider).notificationId;
}

String _$markAllNotificationsReadHash() =>
    r'fb200ac9853e352d65063c698a66933954a69cc3';

/// See also [markAllNotificationsRead].
@ProviderFor(markAllNotificationsRead)
final markAllNotificationsReadProvider =
    AutoDisposeProvider<Future<void> Function()>.internal(
      markAllNotificationsRead,
      name: r'markAllNotificationsReadProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$markAllNotificationsReadHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarkAllNotificationsReadRef =
    AutoDisposeProviderRef<Future<void> Function()>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
