/// App constants, URLs, thresholds, etc.
library;

class AppConstants {
  AppConstants._();

  // API URLs and endpoints
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';

  // App thresholds and limits
  static const int maxProductImages = 5;
  static const int maxProductVideoSize = 10 * 1024 * 1024; // 10MB
  static const int maxProductImageSize = 5 * 1024 * 1024; // 5MB

  // OCR confidence thresholds
  static const double ocrConfidenceThreshold = 0.7;
  static const double geminiValidationThreshold = 0.8;

  // Pagination limits
  static const int itemsPerPage = 20;
  static const int nearbyProductsRadiusKm = 10;

  // Cache durations
  static const Duration offlineCacheDuration = Duration(hours: 24);

  // WhatsApp
  static const String whatsappUrlTemplate = 'https://wa.me/%s?text=%s';

  // Routes
  static const String initialRoute = '/login';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String registerMerchantRoute = '/register/merchant';
  static const String registerClientRoute = '/register/client';
  static const String onboardingRoute = '/onboarding';
  static const String feedRoute = '/feed';
  static const String uploadRoute = '/upload';
  static const String productDetailRoute = '/product/:id';
  static const String merchantDashboardRoute = '/merchant/dashboard';
  static const String merchantProductsRoute = '/merchant/products';
  static const String notificationsRoute = '/notifications';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  static const String favoritesRoute = '/favorites';
}
