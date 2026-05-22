import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';

part 'feed_cache_service.g.dart';

const String _feedBoxName = 'feed_cache';
const String _feedKey = 'products';
const String _filterKey = 'filter';
const String _lastFetchKey = 'last_fetch';
const Duration _cacheDuration = Duration(hours: 24);

class FeedCacheService {
  late Box _box;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _box = await Hive.openBox(_feedBoxName);
    _initialized = true;
  }

  Future<List<Map<String, dynamic>>> getCachedProducts() async {
    await initialize();
    final data = _box.get(_feedKey);
    if (data == null) return [];
    
    final lastFetch = _box.get(_lastFetchKey);
    if (lastFetch != null) {
      final lastFetchTime = DateTime.parse(lastFetch as String);
      if (DateTime.now().difference(lastFetchTime) > _cacheDuration) {
        await clearCache();
        return [];
      }
    }
    
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<void> cacheProducts(List<Product> products) async {
    await initialize();
    final data = products.map((p) => _productToMap(p)).toList();
    await _box.put(_feedKey, data);
    await _box.put(_lastFetchKey, DateTime.now().toIso8601String());
  }

  Future<FeedFilter?> getCachedFilter() async {
    await initialize();
    final filterData = _box.get(_filterKey);
    if (filterData == null) return null;
    
    final map = Map<String, dynamic>.from(filterData as Map);
    return FeedFilter(
      category: map['category'] as String?,
      radiusKm: map['radiusKm'] as double?,
      sortBy: map['sortBy'] as String? ?? 'expiry',
      userLat: map['userLat'] as double?,
      userLng: map['userLng'] as double?,
    );
  }

  Future<void> cacheFilter(FeedFilter filter) async {
    await initialize();
    await _box.put(_filterKey, {
      'category': filter.category,
      'radiusKm': filter.radiusKm,
      'sortBy': filter.sortBy,
      'userLat': filter.userLat,
      'userLng': filter.userLng,
    });
  }

  Future<void> clearCache() async {
    await initialize();
    await _box.delete(_feedKey);
    await _box.delete(_lastFetchKey);
  }

  Map<String, dynamic> _productToMap(Product product) {
    return {
      'id': product.id,
      'merchant_id': product.merchantId,
      'title': product.title,
      'description': product.description,
      'category': product.category,
      'price_original': product.priceOriginal,
      'price_promo': product.pricePromo,
      'expiry_date': product.expiryDate.toIso8601String(),
      'quantity': product.quantity,
      'images': product.images,
      'video_url': product.videoUrl,
      'city': product.city,
      'validated': product.validated,
      'ai_score': product.aiScore,
      'rejection_reason': product.rejectionReason,
      'views_count': product.viewsCount,
      'created_at': product.createdAt.toIso8601String(),
      'likes_count': product.likesCount,
      'comments_count': product.commentsCount,
      'is_liked_by_current_user': product.isLikedByCurrentUser,
      'merchant_name': product.merchantName,
      'merchant_whatsapp': product.merchantWhatsapp,
    };
  }
}

@riverpod
FeedCacheService feedCacheService(Ref ref) => FeedCacheService();
