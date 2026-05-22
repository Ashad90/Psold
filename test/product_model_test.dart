import 'package:flutter_test/flutter_test.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';

void main() {
  group('Product.fromMap', () {
    test('parses full product map correctly', () {
      final map = {
        'id': 'abc-123',
        'merchant_id': 'merchant-1',
        'title': 'Pain frais',
        'description': 'Pain frais du jour',
        'category': 'alimentaire',
        'price_original': 500.0,
        'price_promo': 250.0,
        'expiry_date': '2026-06-15T00:00:00.000',
        'quantity': 10,
        'images': ['https://example.com/img.jpg'],
        'video_url': 'https://example.com/vid.mp4',
        'city': 'Bangui',
        'validated': true,
        'ai_score': 0.95,
        'rejection_reason': null,
        'views_count': 100,
        'created_at': '2026-05-01T10:00:00.000',
        'likes_count': 25,
        'comments_count': 5,
        'is_liked_by_current_user': true,
        'profiles': {'display_name': 'Marchand1', 'whatsapp': '+23670000000'},
      };

      final product = Product.fromMap(map);

      expect(product.id, 'abc-123');
      expect(product.title, 'Pain frais');
      expect(product.description, 'Pain frais du jour');
      expect(product.category, 'alimentaire');
      expect(product.priceOriginal, 500.0);
      expect(product.pricePromo, 250.0);
      expect(product.quantity, 10);
      expect(product.images, ['https://example.com/img.jpg']);
      expect(product.videoUrl, 'https://example.com/vid.mp4');
      expect(product.city, 'Bangui');
      expect(product.validated, true);
      expect(product.aiScore, 0.95);
      expect(product.viewsCount, 100);
      expect(product.likesCount, 25);
      expect(product.commentsCount, 5);
      expect(product.isLikedByCurrentUser, true);
      expect(product.merchantName, 'Marchand1');
      expect(product.merchantWhatsapp, '+23670000000');
    });

    test('parses minimal product map with defaults', () {
      final map = {
        'id': 'min-1',
        'merchant_id': 'm-1',
        'title': 'Minimal',
        'category': 'autre',
        'price_promo': 1000.0,
        'expiry_date': '2026-06-15T00:00:00.000',
        'validated': false,
        'views_count': 0,
        'created_at': '2026-05-01T10:00:00.000',
      };

      final product = Product.fromMap(map);

      expect(product.id, 'min-1');
      expect(product.description, null);
      expect(product.priceOriginal, null);
      expect(product.quantity, 1);
      expect(product.images, []);
      expect(product.videoUrl, null);
      expect(product.city, null);
      expect(product.aiScore, null);
      expect(product.rejectionReason, null);
      expect(product.likesCount, 0);
      expect(product.commentsCount, 0);
      expect(product.isLikedByCurrentUser, false);
      expect(product.merchantName, null);
      expect(product.merchantWhatsapp, null);
    });
  });

  group('Product.fromInsertPayload', () {
    test('parses Realtime payload correctly without profile', () {
      final map = {
        'id': 'rt-1',
        'merchant_id': 'm-1',
        'title': 'Realtime product',
        'category': 'alimentaire',
        'price_promo': 500.0,
        'expiry_date': '2026-06-20T00:00:00.000',
        'validated': true,
        'views_count': 0,
        'created_at': '2026-05-22T10:00:00.000',
      };

      final product = Product.fromInsertPayload(map);

      expect(product.id, 'rt-1');
      expect(product.merchantName, null);
      expect(product.merchantWhatsapp, null);
      expect(product.category, 'alimentaire');
    });
  });

  group('Product.daysUntilExpiry', () {
    test('returns positive days for future expiry', () {
      final now = DateTime.now();
      final product = Product(
        id: 'test',
        merchantId: 'm-1',
        title: 'Future',
        category: 'alimentaire',
        pricePromo: 100,
        expiryDate: now.add(const Duration(days: 30)),
        quantity: 1,
        images: [],
        validated: true,
        viewsCount: 0,
        createdAt: now,
      );
      expect(product.daysUntilExpiry, greaterThanOrEqualTo(29));
      expect(product.daysUntilExpiry, lessThanOrEqualTo(30));
    });

    test('returns negative days for past expiry', () {
      final now = DateTime.now();
      final product = Product(
        id: 'test',
        merchantId: 'm-1',
        title: 'Expired',
        category: 'alimentaire',
        pricePromo: 100,
        expiryDate: now.subtract(const Duration(days: 5)),
        quantity: 1,
        images: [],
        validated: true,
        viewsCount: 0,
        createdAt: now,
      );
      expect(product.daysUntilExpiry, lessThanOrEqualTo(-5));
    });
  });

  group('FeedFilter', () {
    test('defaults to expiry sort', () {
      const filter = FeedFilter();
      expect(filter.sortBy, 'expiry');
      expect(filter.category, null);
      expect(filter.radiusKm, null);
    });

    test('copyWith updates only specified fields', () {
      const filter = FeedFilter(category: 'alimentaire', sortBy: 'popularity');
      final updated = filter.copyWith(category: 'cosmetique');
      expect(updated.category, 'cosmetique');
      expect(updated.sortBy, 'popularity');
      expect(updated.radiusKm, null);
    });
  });
}
