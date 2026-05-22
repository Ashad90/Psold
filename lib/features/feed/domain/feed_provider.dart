import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgresChangeEvent, PostgresChangeFilter, PostgresChangeFilterType, PostgresChangePayload;
import 'package:psold/core/router.dart';
import 'package:psold/shared/utils/feed_cache_service.dart';

part 'feed_provider.g.dart';

final feedFilterProvider = StateProvider<FeedFilter>((ref) => const FeedFilter());

class FeedFilter {
  final String? category;
  final double? radiusKm;
  final String sortBy;
  final double? userLat;
  final double? userLng;

  const FeedFilter({this.category, this.radiusKm, this.sortBy = 'expiry', this.userLat, this.userLng});

  FeedFilter copyWith({String? category, double? radiusKm, String? sortBy, double? userLat, double? userLng}) {
    return FeedFilter(category: category ?? this.category, radiusKm: radiusKm ?? this.radiusKm, sortBy: sortBy ?? this.sortBy, userLat: userLat ?? this.userLat, userLng: userLng ?? this.userLng);
  }
}

class FeedState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final Product? lastProduct;

  const FeedState({this.products = const [], this.isLoading = false, this.isLoadingMore = false, this.hasMore = true, this.error, this.lastProduct});

  FeedState copyWith({List<Product>? products, bool? isLoading, bool? isLoadingMore, bool? hasMore, String? error, Product? lastProduct}) {
    return FeedState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      lastProduct: lastProduct ?? this.lastProduct,
    );
  }
}

@riverpod
class FeedProducts extends _$FeedProducts {
  dynamic _supabase;
  FeedCacheService? _cacheService;
  dynamic _channel;
  static const int _pageSize = 20;

  @override
  FeedState build() {
    _supabase = ref.read(supabaseClientProvider);
    _cacheService = ref.read(feedCacheServiceProvider);
    ref.onDispose(_cleanup);
    _initialize();
    return const FeedState(isLoading: true);
  }

  Future<void> _initialize() async {
    try {
      final cachedProducts = await _cacheService!.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        final products = cachedProducts.map((map) => Product.fromMap(map)).toList();
        state = FeedState(
          products: products,
          isLoading: false,
          hasMore: products.length >= _pageSize,
          lastProduct: products.isNotEmpty ? products.last : null,
        );
        _setupRealtimeSubscription();
        _loadFromNetworkInBackground();
        return;
      }
    } catch (_) {}
    await loadFirstPage();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    try {
      _channel = _supabase.channel('feed');
      _channel!.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'products',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'validated',
          value: true,
        ),
        callback: (payload) {
          _handleRealtimeChange(payload);
        },
      ).subscribe();
    } catch (_) {}
  }

  void _handleRealtimeChange(PostgresChangePayload payload) {
    try {
      final event = payload.eventType;
      final newRecord = payload.newRecord;
      final oldRecord = payload.oldRecord;

      if (event == PostgresChangeEvent.insert && newRecord.isNotEmpty) {
        _handleInsert(newRecord);
      } else if (event == PostgresChangeEvent.update && newRecord.isNotEmpty) {
        _handleUpdate(newRecord);
      } else if (event == PostgresChangeEvent.delete && oldRecord.isNotEmpty) {
        _handleDelete(oldRecord);
      }
    } catch (_) {}
  }

  void _handleInsert(Map<String, dynamic> record) {
    final filter = ref.read(feedFilterProvider);
    if (filter.category != null && record['category'] != filter.category) return;
    if (filter.radiusKm != null) return;

    final product = Product.fromInsertPayload(record);
    if (state.products.any((p) => p.id == product.id)) return;

    state = state.copyWith(
      products: [product, ...state.products],
    );
  }

  void _handleUpdate(Map<String, dynamic> record) {
    final product = Product.fromInsertPayload(record);
    final filter = ref.read(feedFilterProvider);
    if (filter.category != null && product.category != filter.category) {
      state = state.copyWith(
        products: state.products.where((p) => p.id != product.id).toList(),
      );
      return;
    }
    state = state.copyWith(
      products: state.products.map((p) => p.id == product.id ? product : p).toList(),
    );
  }

  void _handleDelete(Map<String, dynamic> record) {
    final deletedId = record['id'] as String?;
    if (deletedId != null) {
      state = state.copyWith(
        products: state.products.where((p) => p.id != deletedId).toList(),
      );
    }
  }

  void _cleanup() {
    _channel?.unsubscribe();
    _channel?.dispose();
  }

  Future<void> _loadFromNetworkInBackground() async {
    try {
      final filter = ref.read(feedFilterProvider);
      final products = await _fetchPage(null, filter);
      await _cacheService!.cacheProducts(products);
      if (state.products.isEmpty) {
        state = FeedState(
          products: products,
          isLoading: false,
          hasMore: products.length >= _pageSize,
          lastProduct: products.isNotEmpty ? products.last : null,
        );
      }
    } catch (_) {}
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final filter = ref.read(feedFilterProvider);
      await _cacheService!.cacheFilter(filter);
      final products = await _fetchPage(null, filter);
      await _cacheService!.cacheProducts(products);
      state = FeedState(
        products: products,
        isLoading: false,
        hasMore: products.length >= _pageSize,
        lastProduct: products.isNotEmpty ? products.last : null,
      );
    } catch (e) {
      final cachedProducts = await _cacheService!.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        final products = cachedProducts.map((map) => Product.fromMap(map)).toList();
        state = FeedState(
          products: products,
          isLoading: false,
          hasMore: products.length >= _pageSize,
          lastProduct: products.isNotEmpty ? products.last : null,
          error: 'Mode hors-ligne: données locales affichées',
        );
      } else {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final filter = ref.read(feedFilterProvider);
      final products = await _fetchPage(state.lastProduct, filter);
      state = state.copyWith(
        products: [...state.products, ...products],
        isLoadingMore: false,
        hasMore: products.length >= _pageSize,
        lastProduct: products.isNotEmpty ? products.last : null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }

  Future<List<Product>> _fetchPage(Product? cursor, FeedFilter filter) async {
    final filterCategory = filter.category;
    final filterSort = filter.sortBy;

    List<Product> results;

    if (filterSort == 'popularity') {
      if (cursor == null) {
        final response = filterCategory == null
            ? await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).order('views_count', ascending: false).limit(_pageSize)
            : await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).eq('category', filterCategory).order('views_count', ascending: false).limit(_pageSize);
        results = (response as List).map((row) => Product.fromMap(Map<String, dynamic>.from(row))).toList();
      } else {
        final response = filterCategory == null
            ? await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).order('views_count', ascending: false).lte('views_count', cursor.viewsCount).limit(_pageSize)
            : await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).eq('category', filterCategory).order('views_count', ascending: false).lte('views_count', cursor.viewsCount).limit(_pageSize);
        results = (response as List).map((row) => Product.fromMap(Map<String, dynamic>.from(row))).toList();
      }
    } else {
      if (cursor == null) {
        final response = filterCategory == null
            ? await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).order('expiry_date', ascending: true).limit(_pageSize)
            : await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).eq('category', filterCategory).order('expiry_date', ascending: true).limit(_pageSize);
        results = (response as List).map((row) => Product.fromMap(Map<String, dynamic>.from(row))).toList();
      } else {
        final response = filterCategory == null
            ? await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).order('expiry_date', ascending: true).gte('expiry_date', cursor.expiryDate.toIso8601String()).neq('created_at', cursor.createdAt.toIso8601String()).limit(_pageSize)
            : await _supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('validated', true).eq('category', filterCategory).order('expiry_date', ascending: true).gte('expiry_date', cursor.expiryDate.toIso8601String()).neq('created_at', cursor.createdAt.toIso8601String()).limit(_pageSize);
        results = (response as List).map((row) => Product.fromMap(Map<String, dynamic>.from(row))).toList();
      }
    }

    return results;
  }
}

class Product {
  final String id;
  final String merchantId;
  final String title;
  final String? description;
  final String category;
  final double? priceOriginal;
  final double pricePromo;
  final DateTime expiryDate;
  final int quantity;
  final List<String> images;
  final String? videoUrl;
  final String? city;
  final bool validated;
  final double? aiScore;
  final String? rejectionReason;
  final int viewsCount;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser;
  final String? merchantName;
  final String? merchantWhatsapp;

  const Product({required this.id, required this.merchantId, required this.title, this.description, required this.category, this.priceOriginal, required this.pricePromo, required this.expiryDate, required this.quantity, required this.images, this.videoUrl, this.city, required this.validated, this.aiScore, this.rejectionReason, required this.viewsCount, required this.createdAt, this.likesCount = 0, this.commentsCount = 0, this.isLikedByCurrentUser = false, this.merchantName, this.merchantWhatsapp});

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  factory Product.fromInsertPayload(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      merchantId: map['merchant_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      priceOriginal: map['price_original'] != null ? (map['price_original'] as num).toDouble() : null,
      pricePromo: (map['price_promo'] as num).toDouble(),
      expiryDate: DateTime.parse(map['expiry_date'] as String),
      quantity: map['quantity'] as int? ?? 1,
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      videoUrl: map['video_url'] as String?,
      city: map['city'] as String?,
      validated: map['validated'] as bool? ?? false,
      aiScore: map['ai_score'] != null ? (map['ai_score'] as num).toDouble() : null,
      rejectionReason: map['rejection_reason'] as String?,
      viewsCount: map['views_count'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      likesCount: map['likes_count'] as int? ?? 0,
      commentsCount: map['comments_count'] as int? ?? 0,
      isLikedByCurrentUser: map['is_liked_by_current_user'] as bool? ?? false,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    return Product(
      id: map['id'] as String,
      merchantId: map['merchant_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      priceOriginal: map['price_original'] != null ? (map['price_original'] as num).toDouble() : null,
      pricePromo: (map['price_promo'] as num).toDouble(),
      expiryDate: DateTime.parse(map['expiry_date'] as String),
      quantity: map['quantity'] as int? ?? 1,
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      videoUrl: map['video_url'] as String?,
      city: map['city'] as String?,
      validated: map['validated'] as bool? ?? false,
      aiScore: map['ai_score'] != null ? (map['ai_score'] as num).toDouble() : null,
      rejectionReason: map['rejection_reason'] as String?,
      viewsCount: map['views_count'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      likesCount: map['likes_count'] as int? ?? 0,
      commentsCount: map['comments_count'] as int? ?? 0,
      isLikedByCurrentUser: map['is_liked_by_current_user'] as bool? ?? false,
      merchantName: profile?['display_name'] as String?,
      merchantWhatsapp: profile?['whatsapp'] as String?,
    );
  }
}

@riverpod
Future<Product> productDetail(Ref ref, String productId) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.from('products').select('*, profiles(display_name, whatsapp)').eq('id', productId).single();
  return Product.fromMap(Map<String, dynamic>.from(response));
}

@riverpod
Future<int> productLikes(Ref ref, String productId) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.from('likes').select().eq('product_id', productId);
  return (response as List).length;
}

@riverpod
Future<void> Function() likeToggle(Ref ref, String productId) {
  return () async {
    final supabase = ref.watch(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    final existing = await supabase.from('likes').select().eq('user_id', userId).eq('product_id', productId).maybeSingle();
    if (existing != null) {
      await supabase.from('likes').delete().eq('id', existing['id']);
    } else {
      await supabase.from('likes').insert({'user_id': userId, 'product_id': productId});
    }
    ref.read(feedProductsProvider.notifier).refresh();
    ref.invalidate(productLikesProvider(productId));
  };
}

class Comment {
  final String id;
  final String userId;
  final String productId;
  final String content;
  final DateTime createdAt;
  final String? userName;

  const Comment({required this.id, required this.userId, required this.productId, required this.content, required this.createdAt, this.userName});

  factory Comment.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    return Comment(id: map['id'] as String, userId: map['user_id'] as String, productId: map['product_id'] as String, content: map['content'] as String, createdAt: DateTime.parse(map['created_at'] as String), userName: profile?['display_name'] as String?);
  }
}

@riverpod
Future<List<Comment>> productComments(Ref ref, String productId) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.from('comments').select('*, profiles(display_name)').eq('product_id', productId).order('created_at', ascending: false).limit(20);
  return (response as List).map((row) => Comment.fromMap(Map<String, dynamic>.from(row))).toList();
}

@riverpod
Future<void> Function(String) addComment(Ref ref, String productId) {
  return (String content) async {
    final supabase = ref.watch(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase.from('comments').insert({'user_id': userId, 'product_id': productId, 'content': content});
    ref.invalidate(productCommentsProvider(productId));
  };
}
