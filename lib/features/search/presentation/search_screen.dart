import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _results = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => _searchController.clear(),
            ),
          ),
          onChanged: _onSearch,
        ),
      ),
      body: _results.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              padding: const EdgeInsets.all(PsoldSpacing.md),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final product = _results[index];
                return ListTile(
                  leading: product.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(product.images.first, width: 50, height: 50, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image),
                  title: Text(product.title),
                  subtitle: Text('${product.pricePromo.toInt()} CFA${product.city != null ? ' - ${product.city}' : ''}'),
                  onTap: () => context.go('/product/${product.id}'),
                );
              },
            ),
    );
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final feedState = ref.read(feedProductsProvider);
    setState(() {
      _results = feedState.products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()) ||
              (p.city?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    });
  }
}