import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/feed/presentation/feed_screen.dart';
import 'package:psold/features/feed/domain/feed_provider.dart';

void main() {
  final now = DateTime.now();

  Widget buildApp(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: psoldLightTheme,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  group('ProductCard', () {
    testWidgets('renders title, price, and city', (WidgetTester tester) async {
      final product = Product(
        id: 'test-1',
        merchantId: 'merchant-1',
        title: 'Pain frais',
        category: 'alimentaire',
        priceOriginal: 500,
        pricePromo: 250,
        expiryDate: now.add(const Duration(days: 15)),
        quantity: 10,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 100,
        createdAt: now,
        likesCount: 25,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.text('Pain frais'), findsOneWidget);
      expect(find.text('Bangui'), findsOneWidget);
      expect(find.textContaining('250 CFA'), findsOneWidget);
      expect(find.textContaining('500 CFA'), findsOneWidget);
    });

    testWidgets('renders promo price only when no original price', (WidgetTester tester) async {
      final product = Product(
        id: 'test-noprice',
        merchantId: 'merchant-1',
        title: 'Pas de prix original',
        category: 'alimentaire',
        pricePromo: 1500,
        expiryDate: now.add(const Duration(days: 30)),
        quantity: 1,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 0,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.textContaining('1500 CFA'), findsOneWidget);
      expect(find.textContaining('CFA'), findsOneWidget);
    });

    testWidgets('renders without city', (WidgetTester tester) async {
      final product = Product(
        id: 'test-nocity',
        merchantId: 'merchant-1',
        title: 'Sans ville',
        category: 'electronique',
        pricePromo: 50000,
        expiryDate: now.add(const Duration(days: 60)),
        quantity: 2,
        images: const [],
        validated: true,
        viewsCount: 5,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.text('Sans ville'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsNothing);
    });

    testWidgets('shows expired badge when product is expired', (WidgetTester tester) async {
      final product = Product(
        id: 'test-expired',
        merchantId: 'merchant-1',
        title: 'Produit périmé',
        category: 'alimentaire',
        pricePromo: 100,
        expiryDate: now.subtract(const Duration(days: 1)),
        quantity: 1,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 0,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.text('Expiré'), findsOneWidget);
    });

    testWidgets('shows expiry badge with days remaining', (WidgetTester tester) async {
      final product = Product(
        id: 'test-2',
        merchantId: 'merchant-1',
        title: 'Produit frais',
        category: 'alimentaire',
        pricePromo: 1000,
        expiryDate: now.add(const Duration(days: 15)),
        quantity: 5,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 10,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.textContaining('jour'), findsOneWidget);
    });

    testWidgets('shows quantity badge', (WidgetTester tester) async {
      final product = Product(
        id: 'test-3',
        merchantId: 'merchant-1',
        title: 'Produit quantité',
        category: 'alimentaire',
        pricePromo: 500,
        expiryDate: now.add(const Duration(days: 20)),
        quantity: 3,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 5,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.textContaining('Qté: 3'), findsOneWidget);
    });

    testWidgets('shows video badge when videoUrl is present', (WidgetTester tester) async {
      final product = Product(
        id: 'test-video',
        merchantId: 'merchant-1',
        title: 'Produit vidéo',
        category: 'cosmetique',
        pricePromo: 3000,
        expiryDate: now.add(const Duration(days: 45)),
        quantity: 1,
        images: const ['https://example.com/img.jpg'],
        videoUrl: 'https://example.com/vid.mp4',
        city: 'Bangui',
        validated: true,
        viewsCount: 10,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    });

    testWidgets('hides video badge when videoUrl is null', (WidgetTester tester) async {
      final product = Product(
        id: 'test-novideo',
        merchantId: 'merchant-1',
        title: 'Sans vidéo',
        category: 'autre',
        pricePromo: 2000,
        expiryDate: now.add(const Duration(days: 10)),
        quantity: 1,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 0,
        createdAt: now,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.byIcon(Icons.play_circle_outline), findsNothing);
    });

    testWidgets('shows likes count', (WidgetTester tester) async {
      final product = Product(
        id: 'test-likes',
        merchantId: 'merchant-1',
        title: 'Produit populaire',
        category: 'alimentaire',
        pricePromo: 1500,
        expiryDate: now.add(const Duration(days: 20)),
        quantity: 5,
        images: const [],
        city: 'Bangui',
        validated: true,
        viewsCount: 50,
        createdAt: now,
        likesCount: 42,
      );

      await tester.pumpWidget(buildApp(ProductCard(product: product)));

      expect(find.text('42'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
