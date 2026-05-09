
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) => UploadRepository());

class UploadRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<String?> uploadImage(dynamic image, String merchantId) async {
    try {
      final fileName = '${merchantId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final bytes = await image.readAsBytes();
      await _supabase.storage.from('products').uploadBinary(fileName, bytes);
      final publicUrl = _supabase.storage.from('products').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> validateWithAI({
    required String title,
    required String category,
    required DateTime expiryDate,
    required List<String> imageUrls,
  }) async {
    try {
      final response = await _supabase.functions.invoke('validate-product', body: {
        'title': title,
        'category': category,
        'expiry_date': expiryDate.toIso8601String().split('T')[0],
        'images_urls': imageUrls,
        'today': DateTime.now().toIso8601String().split('T')[0],
      });
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<void> insertProduct({
    required String merchantId,
    required String title,
    String? description,
    required String category,
    double? priceOriginal,
    required double pricePromo,
    required DateTime expiryDate,
    required int quantity,
    required List<String> images,
    String? city,
    bool validated = false,
    double? aiScore,
  }) async {
    await _supabase.from('products').insert({
      'merchant_id': merchantId,
      'title': title,
      'description': description,
      'category': category,
      'price_original': priceOriginal,
      'price_promo': pricePromo,
      'expiry_date': expiryDate.toIso8601String().split('T')[0],
      'quantity': quantity,
      'images': images,
      'city': city,
      'validated': validated,
      'ai_score': aiScore,
    });
  }
}