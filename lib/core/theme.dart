import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PsoldColors {
  PsoldColors._();

  static const Color backgroundLight = Color(0xFFFDF5E6);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color navBarActiveIndicator = Color(0xFFE1E0E1);
  static const Color navBarActiveIndicatorDark = Color(0xFF000120);
  static const Color primary = Color(0xFFFF6B2B);
  static const Color whatsapp = Color(0xFF25D366);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
}

class PsoldSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

TextTheme _buildTextTheme(TextTheme base) {
  try {
    return GoogleFonts.spaceGroteskTextTheme(base).copyWith(
      displayLarge: const TextStyle(fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -1.5),
      displayMedium: const TextStyle(fontSize: 45, fontWeight: FontWeight.w800, letterSpacing: -1.0),
      displaySmall: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  } catch (e) {
    return base.copyWith(
      displayLarge: const TextStyle(fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -1.5),
      displayMedium: const TextStyle(fontSize: 45, fontWeight: FontWeight.w800, letterSpacing: -1.0),
      displaySmall: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }
}

final psoldLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: PsoldColors.backgroundLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: PsoldColors.backgroundLight,
    brightness: Brightness.light,
    surface: PsoldColors.backgroundLight,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: PsoldColors.backgroundLight,
    indicatorColor: PsoldColors.navBarActiveIndicator,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  textTheme: _buildTextTheme(ThemeData.light().textTheme),
  useMaterial3: true,
);

final psoldDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: PsoldColors.backgroundDark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: PsoldColors.backgroundDark,
    brightness: Brightness.dark,
    surface: PsoldColors.backgroundDark,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: PsoldColors.backgroundDark,
    indicatorColor: PsoldColors.navBarActiveIndicatorDark,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  textTheme: _buildTextTheme(ThemeData.dark().textTheme),
  useMaterial3: true,
);