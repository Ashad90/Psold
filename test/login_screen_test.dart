import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('renders email and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: psoldLightTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Adresse e-mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('shows Google sign-in button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: psoldLightTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Continuer avec Google'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('empty fields show validation error', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: psoldLightTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Se connecter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Veuillez entrer email et mot de passe'), findsOneWidget);
  });

  testWidgets('Créer un compte navigates to register route', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: psoldLightTheme,
          routerConfig: GoRouter(
            initialLocation: '/login',
            routes: [
              GoRoute(
                path: '/login',
                builder: (_, __) => const LoginScreen(),
              ),
              GoRoute(
                path: '/register',
                builder: (_, __) => const Scaffold(
                  body: Center(child: Text('Register Page')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Créer un compte'), findsOneWidget);
    await tester.ensureVisible(find.text('Créer un compte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Créer un compte'));
    await tester.pumpAndSettle();
    expect(find.text('Register Page'), findsOneWidget);
  });
}
