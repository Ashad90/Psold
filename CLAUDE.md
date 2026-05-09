# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🚀 Common Commands

### Flutter Development
- `flutter run` - Run the app on a connected device/emulator
- `flutter pub get` - Get dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter analyze` - Run static analysis (linting)
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run a specific test
- `flutter gen-l10n` - Generate localization files after modifying ARB files
- `dart run flutter_native_splash:create` - Generate splash screen (run once)
- `dart run flutter_launcher_icons` - Generate launcher icons (run once)
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS IPA
- `flutter clean` - Clean build artifacts

### State Management & Code Generation
- `flutter pub run build_runner build` - Generate Riverpod, freezed, and json_serializable code
- `flutter pub run build_runner watch` - Watch for changes and regenerate

### Internationalization
- After modifying ARB files in `lib/l10n/`, run `flutter gen-l10n` to update generated localization code

## 🏗️ Project Architecture

### Core Structure
```
lib/
├── main.dart              # App entry point with ProviderScope and GoRouter initialization
├── core/
│   ├── supabase_client.dart   # Singleton Supabase client initialization
│   ├── router.dart            # GoRouter configuration with auth/role guards
│   ├── theme.dart             # PsoldColors, PsoldSpacing, and ThemeData configuration
│   ├── constants.dart         # App constants, URLs, thresholds
│   └── locale_provider.dart   # Riverpod provider for language/locale management (Hive persisted)
├── features/
│   ├── auth/                  # Authentication flows (login, registration, onboarding)
│   ├── feed/                  # Product feed with filtering, geolocation, real-time updates
│   ├── upload/                # Product upload flow (camera, OCR, form, IA validation)
│   ├── product/               # Product detail screen with likes, comments, WhatsApp contact
│   ├── merchant/              # Merchant dashboard and product management
│   ├── search/                # Product search functionality
│   ├── notifications/         # Push notifications handling
│   └── settings/              # User settings and profile management
├── shared/
│   ├── widgets/               # Reusable custom widgets (_RoleCard, ProductCard, etc.)
│   ├── models/                # Data models (freezed + json_serializable)
│   ├── providers/             # Shared providers (auth_provider, currentUserProvider, etc.)
│   └── utils/                 # Helper functions (date formatting, WhatsApp intents, etc.)
```

### Key Architectural Patterns
- **State Management**: Riverpod 2.x with `@riverpod` annotations for all providers
- **Navigation**: GoRouter with role-based guards (merchant vs client restrictions)
- **Dependency Injection**: ProviderScope at root, providers accessed via `ref.watch()` and `ref.read()`
- **Localization**: ARB files in `lib/l10n/` with `flutter_gen` for type-safe localization
- **Theme System**: Centralized `PsoldColors` and `PsoldSpacing` classes, light/dark themes
- **Internationalization**: Full support for French (LTR), English (LTR), and Arabic (RTL) with automatic UI mirroring
- **Error Handling**: Explicit error handling with `whenOrNull` listeners on providers
- **Performance**: Const widgets everywhere, RepaintBoundary for complex widgets, lazy lists

### Critical Implementation Rules
1. **Role Separation**: Merchant and client accounts have strictly different capabilities
   - Merchants can upload products, access dashboard, see no "Discuter" button
   - Clients can browse feed, like/comment, see "Discuter" (WhatsApp) button, no upload access
2. **UI Consistency**: 
   - All colors from `PsoldColors` or `Theme.of(context).colorScheme*`
   - All spacing multiples of 8px (PsoldSpacing class)
   - Corner radius: 20px for main cards, 12px for secondary elements
   - Use `EdgeInsetsDirectional` and `TextAlign.start` for RTL support
3. **Performance Constraints**: App must cold-start in <1s on mid-range devices
4. **Security**: 
   - No API keys in client code (use `--dart-define` or Supabase Edge Functions)
   - Row Level Security enabled on all Supabase tables
   - Validate E.164 WhatsApp format client-side before saving

### Database Schema (Supabase/PostgreSQL)
- `profiles`: Extends Supabase auth.users with role (merchant/client), display_name, WhatsApp, location
- `products`: Merchant-uploaded items with validation status, expiry dates, AI scoring
- `likes`: User-product likes with unique constraint
- `comments`: User comments on products
- Row Level Security policies restrict access based on user role and ownership

### Localization & Internationalization
- Supported locales: fr (default), en, ar (Arabic RTL)
- ARB files in `lib/l10n/` (app_fr.arb, app_en.arb, app_ar.arb)
- Generate code with `flutter gen-l10n`
- Access via `AppLocalizations.of(context)!`
- Language persistence via Hive + Riverpod localeProvider
- RTL implementation: Use Directionality checks, EdgeInsetsDirectional, TextAlign.start

## 🔧 Development Workflow

Following the MMM (Make it Work → Make it Right → Make it Fast) methodology from SPEC.md:

1. **Phase 1 - Setup, Auth, Navigation**: 
   - Initialize Flutter project with Impeller
   - Configure Supabase client
   - Implement GoRouter with auth/role guards
   - Create authentication screens (login, registration, onboarding)
   - Implement role-based bottom navigation bars

2. **Phase 2 - Upload & Validation IA**:
   - Implement camera/image picker with compression
   - Integrate ML Kit Text Recognition for expiry date OCR
   - Create upload form with auto-fill from OCR
   - Call Supabase Edge Function for Gemini AI validation
   - Handle upload to Supabase Storage and product database insertion

3. **Phase 3 - Feed & Interactions**:
   - Implement real-time feed with Supabase Realtime StreamProvider
   - Add filtering by category, distance, sorting
   - Create product cards with countdown badges
   - Implement optimistic like updates and comment systems
   - Add WhatsApp contact button (client-only)

4. **Phase 4 - Merchant Dashboard, Offline, Notifications**:
   - Build merchant dashboard with statistics
   - Implement "My products" management screen
   - Add offline caching (Hive for feed, flutter_cache_manager for images)
   - Implement FCM push notifications
   - Add background location updates

5. **Phase 5 - Deployment**:
   - Configure Codemagic for iOS/Android builds
   - Set up monitoring (Sentry + Supabase Dashboard)
   - Conduct load testing (100 concurrent users)

## 📱 Platform-Specific Notes

- **Android**: Enable Impeller (performance), minimum SDK 21
- **iOS**: Enable Impeller by default
- **Web**: Not targeted for this MVP (generate: false in launcher icons config)
- **Assets**: Store images in `assets/images/`, Lottie animations in `assets/animations/`
- **Fonts**: Space Grotesk recommended for typography (add google_fonts dependency)

## 🧪 Testing

- Widget tests in `test/` directory
- Run specific tests: `flutter test test/widget_test.dart`
- Update golden files when UI changes intentionally: `flutter test --update-goldens`
- Aim for test coverage on critical paths (auth, upload, feed)