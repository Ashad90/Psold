// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailHash() => r'18b6cdd31cdd9b7dc8e697bfa923b1796cd823d1';

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

/// See also [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [productDetail].
class ProductDetailFamily extends Family<AsyncValue<Product>> {
  /// See also [productDetail].
  const ProductDetailFamily();

  /// See also [productDetail].
  ProductDetailProvider call(String productId) {
    return ProductDetailProvider(productId);
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [productDetail].
class ProductDetailProvider extends AutoDisposeFutureProvider<Product> {
  /// See also [productDetail].
  ProductDetailProvider(String productId)
    : this._internal(
        (ref) => productDetail(ref as ProductDetailRef, productId),
        from: productDetailProvider,
        name: r'productDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productDetailHash,
        dependencies: ProductDetailFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<Product> Function(ProductDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product> createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef on AutoDisposeFutureProviderRef<Product> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductDetailProviderElement
    extends AutoDisposeFutureProviderElement<Product>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  String get productId => (origin as ProductDetailProvider).productId;
}

String _$productLikesHash() => r'bf0d6cf3a39e4ad2dbd4ad72657b4778a413d23f';

/// See also [productLikes].
@ProviderFor(productLikes)
const productLikesProvider = ProductLikesFamily();

/// See also [productLikes].
class ProductLikesFamily extends Family<AsyncValue<int>> {
  /// See also [productLikes].
  const ProductLikesFamily();

  /// See also [productLikes].
  ProductLikesProvider call(String productId) {
    return ProductLikesProvider(productId);
  }

  @override
  ProductLikesProvider getProviderOverride(
    covariant ProductLikesProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productLikesProvider';
}

/// See also [productLikes].
class ProductLikesProvider extends AutoDisposeFutureProvider<int> {
  /// See also [productLikes].
  ProductLikesProvider(String productId)
    : this._internal(
        (ref) => productLikes(ref as ProductLikesRef, productId),
        from: productLikesProvider,
        name: r'productLikesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productLikesHash,
        dependencies: ProductLikesFamily._dependencies,
        allTransitiveDependencies:
            ProductLikesFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductLikesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<int> Function(ProductLikesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductLikesProvider._internal(
        (ref) => create(ref as ProductLikesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _ProductLikesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductLikesProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductLikesRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductLikesProviderElement extends AutoDisposeFutureProviderElement<int>
    with ProductLikesRef {
  _ProductLikesProviderElement(super.provider);

  @override
  String get productId => (origin as ProductLikesProvider).productId;
}

String _$likeToggleHash() => r'aeb1a4c18aca5dbd9086e9a511ab4c41024b8c00';

/// See also [likeToggle].
@ProviderFor(likeToggle)
const likeToggleProvider = LikeToggleFamily();

/// See also [likeToggle].
class LikeToggleFamily extends Family<Future<void> Function()> {
  /// See also [likeToggle].
  const LikeToggleFamily();

  /// See also [likeToggle].
  LikeToggleProvider call(String productId) {
    return LikeToggleProvider(productId);
  }

  @override
  LikeToggleProvider getProviderOverride(
    covariant LikeToggleProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'likeToggleProvider';
}

/// See also [likeToggle].
class LikeToggleProvider extends AutoDisposeProvider<Future<void> Function()> {
  /// See also [likeToggle].
  LikeToggleProvider(String productId)
    : this._internal(
        (ref) => likeToggle(ref as LikeToggleRef, productId),
        from: likeToggleProvider,
        name: r'likeToggleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$likeToggleHash,
        dependencies: LikeToggleFamily._dependencies,
        allTransitiveDependencies: LikeToggleFamily._allTransitiveDependencies,
        productId: productId,
      );

  LikeToggleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    Future<void> Function() Function(LikeToggleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LikeToggleProvider._internal(
        (ref) => create(ref as LikeToggleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Future<void> Function()> createElement() {
    return _LikeToggleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LikeToggleProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LikeToggleRef on AutoDisposeProviderRef<Future<void> Function()> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _LikeToggleProviderElement
    extends AutoDisposeProviderElement<Future<void> Function()>
    with LikeToggleRef {
  _LikeToggleProviderElement(super.provider);

  @override
  String get productId => (origin as LikeToggleProvider).productId;
}

String _$productCommentsHash() => r'2ac07b7694899f10c4bceef8959e8fb4c7fca565';

/// See also [productComments].
@ProviderFor(productComments)
const productCommentsProvider = ProductCommentsFamily();

/// See also [productComments].
class ProductCommentsFamily extends Family<AsyncValue<List<Comment>>> {
  /// See also [productComments].
  const ProductCommentsFamily();

  /// See also [productComments].
  ProductCommentsProvider call(String productId) {
    return ProductCommentsProvider(productId);
  }

  @override
  ProductCommentsProvider getProviderOverride(
    covariant ProductCommentsProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productCommentsProvider';
}

/// See also [productComments].
class ProductCommentsProvider extends AutoDisposeFutureProvider<List<Comment>> {
  /// See also [productComments].
  ProductCommentsProvider(String productId)
    : this._internal(
        (ref) => productComments(ref as ProductCommentsRef, productId),
        from: productCommentsProvider,
        name: r'productCommentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productCommentsHash,
        dependencies: ProductCommentsFamily._dependencies,
        allTransitiveDependencies:
            ProductCommentsFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<List<Comment>> Function(ProductCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductCommentsProvider._internal(
        (ref) => create(ref as ProductCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Comment>> createElement() {
    return _ProductCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductCommentsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductCommentsRef on AutoDisposeFutureProviderRef<List<Comment>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductCommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Comment>>
    with ProductCommentsRef {
  _ProductCommentsProviderElement(super.provider);

  @override
  String get productId => (origin as ProductCommentsProvider).productId;
}

String _$addCommentHash() => r'1de4707170726f251765fa438d07697dc6d0ed1f';

/// See also [addComment].
@ProviderFor(addComment)
const addCommentProvider = AddCommentFamily();

/// See also [addComment].
class AddCommentFamily extends Family<Future<void> Function(String)> {
  /// See also [addComment].
  const AddCommentFamily();

  /// See also [addComment].
  AddCommentProvider call(String productId) {
    return AddCommentProvider(productId);
  }

  @override
  AddCommentProvider getProviderOverride(
    covariant AddCommentProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addCommentProvider';
}

/// See also [addComment].
class AddCommentProvider
    extends AutoDisposeProvider<Future<void> Function(String)> {
  /// See also [addComment].
  AddCommentProvider(String productId)
    : this._internal(
        (ref) => addComment(ref as AddCommentRef, productId),
        from: addCommentProvider,
        name: r'addCommentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$addCommentHash,
        dependencies: AddCommentFamily._dependencies,
        allTransitiveDependencies: AddCommentFamily._allTransitiveDependencies,
        productId: productId,
      );

  AddCommentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    Future<void> Function(String) Function(AddCommentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddCommentProvider._internal(
        (ref) => create(ref as AddCommentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Future<void> Function(String)> createElement() {
    return _AddCommentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddCommentProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddCommentRef on AutoDisposeProviderRef<Future<void> Function(String)> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _AddCommentProviderElement
    extends AutoDisposeProviderElement<Future<void> Function(String)>
    with AddCommentRef {
  _AddCommentProviderElement(super.provider);

  @override
  String get productId => (origin as AddCommentProvider).productId;
}

String _$feedProductsHash() => r'bc5baadaa784c2020e0f646eb0b94bab13e557f4';

/// See also [FeedProducts].
@ProviderFor(FeedProducts)
final feedProductsProvider =
    AutoDisposeNotifierProvider<FeedProducts, FeedState>.internal(
      FeedProducts.new,
      name: r'feedProductsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedProductsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedProducts = AutoDisposeNotifier<FeedState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
