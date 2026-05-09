import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/router.dart';

class MerchantStats {
  final int activeProducts;
  final int totalViews;
  final int totalLikes;
  final int expiringProducts;
  final int pendingProducts;
  final int rejectedProducts;
  final bool isLoading;
  final String? error;

  const MerchantStats({
    this.activeProducts = 0,
    this.totalViews = 0,
    this.totalLikes = 0,
    this.expiringProducts = 0,
    this.pendingProducts = 0,
    this.rejectedProducts = 0,
    this.isLoading = false,
    this.error,
  });

  MerchantStats copyWith({
    int? activeProducts,
    int? totalViews,
    int? totalLikes,
    int? expiringProducts,
    int? pendingProducts,
    int? rejectedProducts,
    bool? isLoading,
    String? error,
  }) {
    return MerchantStats(
      activeProducts: activeProducts ?? this.activeProducts,
      totalViews: totalViews ?? this.totalViews,
      totalLikes: totalLikes ?? this.totalLikes,
      expiringProducts: expiringProducts ?? this.expiringProducts,
      pendingProducts: pendingProducts ?? this.pendingProducts,
      rejectedProducts: rejectedProducts ?? this.rejectedProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MerchantStatsNotifier extends StateNotifier<MerchantStats> {
  final dynamic _supabase;
  final String _merchantId;

  MerchantStatsNotifier(this._supabase, this._merchantId) : super(const MerchantStats(isLoading: true)) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final now = DateTime.now();
      final weekFromNow = now.add(const Duration(days: 7));

      final activeResp = await (_supabase.from('products').select('id', count: 'exact').eq('merchant_id', _merchantId).eq('validated', true) as dynamic);
      final activeCount = activeResp.count as int? ?? 0;

      final viewsResp = await _supabase.from('products').select('views_count').eq('merchant_id', _merchantId).eq('validated', true);
      int totalViews = 0;
      for (final row in viewsResp as List) {
        totalViews += (row['views_count'] as int? ?? 0);
      }

      final likesResp = await (_supabase.from('likes').select('id', count: 'exact').eq('user_id', _merchantId) as dynamic);
      final likesCount = likesResp.count as int? ?? 0;

      final expiringResp = await (_supabase.from('products').select('id', count: 'exact').eq('merchant_id', _merchantId).eq('validated', true).lt('expiry_date', weekFromNow.toIso8601String()) as dynamic);
      final expiringCount = expiringResp.count as int? ?? 0;

      final pendingResp = await (_supabase.from('products').select('id', count: 'exact').eq('merchant_id', _merchantId).eq('validated', false).is_('rejection_reason', null) as dynamic);
      final pendingCount = pendingResp.count as int? ?? 0;

      final rejectedResp = await (_supabase.from('products').select('id', count: 'exact').eq('merchant_id', _merchantId).is_('rejection_reason', 'not.is.null') as dynamic);
      final rejectedCount = rejectedResp.count as int? ?? 0;

      state = MerchantStats(
        activeProducts: activeCount,
        totalViews: totalViews,
        totalLikes: likesCount,
        expiringProducts: expiringCount,
        pendingProducts: pendingCount,
        rejectedProducts: rejectedCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => loadStats();
}

final merchantStatsProvider = StateNotifierProvider<MerchantStatsNotifier, MerchantStats>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final profile = ref.watch(currentUserProvider);
  final merchantId = profile?.id;
  if (merchantId == null) {
    return MerchantStatsNotifier(supabase, '');
  }
  return MerchantStatsNotifier(supabase, merchantId);
});

enum MerchantProductStatus { all, active, pending, rejected }

final merchantProductStatusProvider = StateProvider<MerchantProductStatus>((ref) => MerchantProductStatus.all);

class MerchantProduct {
  final String id;
  final String title;
  final String category;
  final double pricePromo;
  final double? priceOriginal;
  final DateTime expiryDate;
  final int quantity;
  final List<String> images;
  final bool validated;
  final double? aiScore;
  final String? rejectionReason;
  final int viewsCount;
  final int likesCount;
  final DateTime createdAt;

  const MerchantProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.pricePromo,
    this.priceOriginal,
    required this.expiryDate,
    required this.quantity,
    required this.images,
    required this.validated,
    this.aiScore,
    this.rejectionReason,
    required this.viewsCount,
    required this.likesCount,
    required this.createdAt,
  });

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  factory MerchantProduct.fromMap(Map<String, dynamic> map) {
    return MerchantProduct(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      pricePromo: (map['price_promo'] as num).toDouble(),
      priceOriginal: map['price_original'] != null ? (map['price_original'] as num).toDouble() : null,
      expiryDate: DateTime.parse(map['expiry_date'] as String),
      quantity: map['quantity'] as int? ?? 1,
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      validated: map['validated'] as bool? ?? false,
      aiScore: map['ai_score'] != null ? (map['ai_score'] as num).toDouble() : null,
      rejectionReason: map['rejection_reason'] as String?,
      viewsCount: map['views_count'] as int? ?? 0,
      likesCount: map['likes_count'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class MerchantProductsState {
  final List<MerchantProduct> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  const MerchantProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  MerchantProductsState copyWith({
    List<MerchantProduct>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return MerchantProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class MerchantProductsNotifier extends StateNotifier<MerchantProductsState> {
  final dynamic _supabase;
  final String _merchantId;
  final Ref _ref;
  static const int _pageSize = 20;

  MerchantProductsNotifier(this._supabase, this._merchantId, this._ref) : super(const MerchantProductsState(isLoading: true)) {
    if (_merchantId.isNotEmpty) loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _fetchPage(null);
      state = MerchantProductsState(
        products: products,
        isLoading: false,
        hasMore: products.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.products.isEmpty) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final products = await _fetchPage(state.products.last);
      state = state.copyWith(
        products: [...state.products, ...products],
        isLoadingMore: false,
        hasMore: products.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }

  Future<List<MerchantProduct>> _fetchPage(MerchantProduct? cursor) async {
    final status = _ref.read(merchantProductStatusProvider);
    var query = _supabase
        .from('products')
        .select('*, likes(count)')
        .eq('merchant_id', _merchantId)
        .order('created_at', ascending: false)
        .limit(_pageSize);

    if (cursor != null) {
      query = query.lt('created_at', cursor.createdAt.toIso8601String());
    }

    switch (status) {
      case MerchantProductStatus.active:
        query = query.eq('validated', true);
        break;
      case MerchantProductStatus.pending:
        query = query.eq('validated', false).is_('rejection_reason', null);
        break;
      case MerchantProductStatus.rejected:
        query = query.is_('rejection_reason', 'not.is.null');
        break;
      case MerchantProductStatus.all:
        break;
    }

    final response = await query;
    return (response as List).map((row) {
      final likesCount = (row['likes'] as List?)?.length ?? 0;
      final map = Map<String, dynamic>.from(row);
      map['likes_count'] = likesCount;
      return MerchantProduct.fromMap(map);
    }).toList();
  }
}

final merchantProductsProvider = StateNotifierProvider<MerchantProductsNotifier, MerchantProductsState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final profile = ref.watch(currentUserProvider);
  final merchantId = profile?.id ?? '';
  return MerchantProductsNotifier(supabase, merchantId, ref);
});

final merchantProductDeleteProvider = Provider.family<Future<void> Function(), String>((ref, productId) {
  return () async {
    final supabase = ref.watch(supabaseClientProvider);
    await supabase.from('products').delete().eq('id', productId);
    ref.read(merchantProductsProvider.notifier).refresh();
    ref.invalidate(merchantStatsProvider);
  };
});