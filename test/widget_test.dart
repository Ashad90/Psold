import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('Login screen renders all key elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: psoldLightTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Les Produits en Solde'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Téléphone'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Continuer avec Google'), findsOneWidget);
    expect(find.text('Créer un compte'), findsOneWidget);
  });
}
