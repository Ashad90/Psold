import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';
import 'package:psold/features/search/domain/search_provider.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher un produit...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearch('');
              },
            ),
          ),
          onChanged: _onSearch,
        ),
      ),
      body: _buildBody(resultsAsync),
    );
  }

  Widget _buildBody(AsyncValue<List<Product>> asyncResults) {
    if (_query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: PsoldSpacing.md),
            Text(
              'Tapez pour rechercher',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return asyncResults.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: PsoldSpacing.md),
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: PsoldSpacing.md),
                Text(
                  "Aucun résultat pour '$_query'",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsetsDirectional.all(PsoldSpacing.md),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return Padding(
              padding: const EdgeInsetsDirectional.only(bottom: PsoldSpacing.sm),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => context.go('/product/${product.id}'),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(PsoldSpacing.sm),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: product.images.isNotEmpty
                                ? Image.network(product.images.first, fit: BoxFit.cover)
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                          ),
                        ),
                        const SizedBox(width: PsoldSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: PsoldSpacing.xs),
                              Text(
                                '${product.pricePromo.toInt()} CFA${product.city != null ? ' - ${product.city}' : ''}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PsoldColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
