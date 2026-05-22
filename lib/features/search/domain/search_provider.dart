import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:psold/core/router.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';

part 'search_provider.g.dart';

@riverpod
Future<List<Product>> searchResults(Ref ref, String query) async {
  if (query.trim().isEmpty) return [];

  final supabase = ref.watch(supabaseClientProvider);

  String searchTitle = query.trim();
  String? searchCity;

  if (query.contains(' - ')) {
    final parts = query.split(' - ');
    searchTitle = parts[0].trim();
    if (parts.length > 1) {
      searchCity = parts[1].trim();
    }
  }

  final keywords = searchTitle.replaceAll(
    RegExp(r'\b(en|de|le|la|les|du|des|au|aux|pour|sur|avec|dans|ou|et)\b', caseSensitive: false),
    '',
  ).trim();
  final searchTerm = keywords.isEmpty ? searchTitle : keywords;

  var queryBuilder = supabase
      .from('products')
      .select('*, profiles(display_name, whatsapp)')
      .eq('validated', true)
      .ilike('title', '%$searchTerm%');

  if (searchCity != null && searchCity.isNotEmpty) {
    queryBuilder = queryBuilder.ilike('city', '%$searchCity%');
  }

  final response = await queryBuilder.order('expiry_date', ascending: true).limit(50);

  return (response as List).map((row) => Product.fromMap(Map<String, dynamic>.from(row))).toList();
}
