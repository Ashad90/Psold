# AGENTS.md — Psold

## Essential Commands

| Task | Command |
|------|---------|
| Lint/typecheck | `flutter analyze` |
| Run tests | `flutter test` |
| Run specific test | `flutter test test/widget_test.dart` |
| Update golden files | `flutter test --update-goldens` |
| Generate localization | `flutter gen-l10n` |
| Code generation (riverpod/freezed/json) | `flutter pub run build_runner build` |
| Watch & regenerate | `flutter pub run build_runner watch` |
| Clean rebuild | `flutter clean && flutter pub get` |
| Build debug APK | `flutter build apk --debug` |
| Generate splash (one-time) | `dart run flutter_native_splash:create` |
| Generate launcher icons (one-time) | `dart run flutter_launcher_icons` |

**Order**: `build_runner` → `flutter analyze` → `flutter test`. Always run `build_runner` after adding `@riverpod`/`freezed`/`json_serializable` annotations.

**SDK**: Dart `^3.11.5`

## Architecture

- Entry point: `lib/main.dart` — `ProviderScope` + GoRouter + Firebase init + Hive box `'settings'` opened before `runApp`
- State: Riverpod 2.x with `@riverpod` annotations (run `build_runner` after adding)
- Navigation: GoRouter with auth/role guards in `lib/core/router.dart`
- Auth flow: Google users → `/google-profile-setup` → `/onboarding` → `/feed`; email users → `/onboarding` → `/feed`
- Auto-logout after 7 days inactive (`shouldAutoLogout()` in `currentUserProvider` notifier)
- Theme: `PsoldColors` and `PsoldSpacing` from `lib/core/theme.dart` — never hardcode colors/spacing
- RTL: Use `EdgeInsetsDirectional`, `TextAlign.start`, `Directionality.of(context)` — don't assume LTR
- Supabase client: singleton at `lib/core/supabase_client.dart` — init via `--dart-define` env vars; falls back to hardcoded dev values in the class
- Fonts: Space Grotesk via `google_fonts` (loaded at runtime, no bundled fonts)

## Key Sources

- **SPEC.md**: Full product specs, DB schema, design tokens, RLS policies, business rules — read before any task
- **START_HERE.md**: 25-phase task workflow, skill activation, execution sequence
- **lib/core/**: `router.dart` (routes+guards), `theme.dart` (colors/spacing), `supabase_client.dart`, `locale_provider.dart`, `constants.dart`
- **lib/l10n/**: ARB source files (`app_fr.arb`, `app_en.arb`, `app_ar.arb`) — `generate: true` in pubspec.yaml outputs to `lib/flutter_gen/gen_l10n/`

## Directory Layout

```
lib/
├── main.dart                  # Entry point
├── core/                      # supabase_client, router, theme, locale_provider, constants
├── features/                  # auth, feed, upload, product, merchant, search, notifications, settings, splash
├── shared/                    # widgets, models, utils, providers
├── l10n/                      # ARB source + generated dart files (do not edit generated)
└── flutter_gen/gen_l10n/      # Auto-generated localization code (do not edit)
```

## Supabase CLI

CLI at `supabase.exe` in project root. Requires access token from https://app.supabase.com/account/tokens.

| Task | Command |
|------|---------|
| Login | `supabase.exe login --token <token>` |
| Link project | `supabase.exe link --project-ref dsflswhxvjnvkedhrynd` |
| Push migrations | `supabase.exe db push --yes` |
| Run SQL query | `supabase.exe db query --linked --file path/to/file.sql` |

**Never modify existing migrations** — remote already has the schema. Add only new numbered migrations (`005_...`).

## Design Rules

- All spacing: multiples of 8px (`PsoldSpacing.xs=4` to `PsoldSpacing.xxxl=64`)
- Cards: `BorderRadius.circular(20)` primary, `12` secondary
- Primary button: `#FF6B2B` orange (`PsoldColors.primary`)
- WhatsApp button (`#25D366`): only visible when `profile.role == 'client'`
- WhatsApp number format: E.164 (`+[country][number]`)
- Skeleton loaders for loading states — never `CircularProgressIndicator` alone
- Use `Material3` (enabled in theme)

## Navigation Bar

- **Client**: Accueil | Favoris | Alertes | Paramètres
- **Merchant**: Accueil | Publier | Mes produits | Alertes | Paramètres
- Role-based nav rendered in `_NavScaffold` (`lib/core/router.dart:158`)

## Database (Supabase/PostgreSQL)

- `profiles`: Extends `auth.users` with `role` (merchant/client), `display_name`, `whatsapp`, `avatar_url`, `city`, `fcm_token`, `last_active`
- `products`: Merchant-uploaded items with validation status, AI score, expiry dates
- `likes`: User-product likes with unique(user_id, product_id)
- `comments`: User comments on products
- `notifications`: User notifications with type, is_read
- RLS enforced on all tables — profiles publicly readable, products restricted by validation+ownership, likes/comments by auth

## Quirks

- `_role_card.dart` in `shared/widgets/` is a private file exporting `RoleCard` class — do not move or rename
- `_psold_scaffold.dart` in `shared/widgets/` defines `PsoldScaffold`/`PsoldShell` but these are **not imported anywhere** (unused — router uses `_NavScaffold` instead)
- `lib/l10n/` contains both ARB sources AND generated dart files; the actual auto-generated output used at runtime is in `lib/flutter_gen/gen_l10n/`
- Assets: `assets/images/` and `assets/animations/` (defined in pubspec.yaml)
- Notification service via `notificationServiceProvider` (Riverpod `Provider`) in `shared/utils/notification_service.dart`
- Dark theme: `psoldDarkTheme` in `lib/core/theme.dart`
- App language: French market (FR / EN / AR support)
- Sentry DSN: optional, set via `SENTRY_DSN` env var (defaults to empty/disabled)
- Splash screen uses Lottie at `assets/animations/psold_logo_animation.json`
- One-time visual setup: `dart run flutter_native_splash:create` and `dart run flutter_launcher_icons` after changing config yamls
