# AGENTS.md — Psold

## Essential Commands

| Task | Command |
|------|---------|
| Lint/typecheck | `flutter analyze` |
| Run all tests | `flutter test` |
| Run single test | `flutter test test/<file>` |
| Update golden files | `flutter test --update-goldens` |
| Gen localization | `flutter gen-l10n` |
| Codegen (riverpod/freezed/json) | `flutter pub run build_runner build` |
| Watch & regenerate | `flutter pub run build_runner watch` |
| Clean rebuild | `flutter clean && flutter pub get` |
| Build release APK | `flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=GOOGLE_CLIENT_ID=...` |
| Splash (one-time) | `dart run flutter_native_splash:create` |
| Icons (one-time) | `dart run flutter_launcher_icons` |

**Order**: `build_runner` → `flutter analyze` → `flutter test`. Run `build_runner` after adding `@riverpod`/`freezed`/`json_serializable` annotations.

**SDK**: Dart `^3.11.5`

## Entrypoint & Init

`lib/main.dart`: `ProviderScope` + GoRouter + Firebase init + Sentry (opt-in via `--dart-define=SENTRY_DSN=<dsn>`) + Hive box `'settings'` opened before `runApp`. `debugShowCheckedModeBanner: false`.

Package imports use `package:psold/...`.

## Architecture

- **Auth**: Supabase Auth (email + Google Sign-In). Google flow → `/google-profile-setup` → `/onboarding` → `/feed`. Email flow → `/onboarding` → `/feed`.
- **State**: Riverpod 2.x with `@riverpod` annotations. Providers in `lib/core/router.dart`: `supabaseClientProvider`, `authStateProvider`, `currentUserProvider` (StateNotifier with `UserProfile`), `merchantBackgroundLocationProvider`.
- **Navigation**: GoRouter with auth/role guards in `lib/core/router.dart`. Role-aware shell via `_NavScaffold` + `_RoleAwareBranch`. 5 `StatefulShellBranch` entries — branch indices map to nav bar items.
- **Theme**: `PsoldColors` and `PsoldSpacing` from `lib/core/theme.dart` — never hardcode colors/spacing. Material3 enabled.
- **RTL**: Use `EdgeInsetsDirectional`, `TextAlign.start`, `Directionality.of(context)`. Supported locales: fr (default), en, ar.
- **Supabase client**: Singleton at `lib/core/supabase_client.dart` — init via `--dart-define` env vars; falls back to hardcoded dev values (safe — anon key with RLS).
- **Fonts**: Space Grotesk via `google_fonts` (runtime, no bundled fonts).
- **Sentry**: optional, `--dart-define=SENTRY_DSN=<dsn>` (defaults disabled).

## Navigation Bar (role-based, in `_NavScaffold`)

| Tab | Merchant | Client |
|-----|----------|--------|
| 0 | Accueil | Accueil |
| 1 | Publier | Favoris |
| 2 | Mes produits | Alertes |
| 3 | Alertes | Paramètres |
| 4 | Paramètres | — |

## Design Rules

- All spacing: multiples of 8px (`PsoldSpacing.xs=4` to `PsoldSpacing.xxxl=64`)
- Cards: `BorderRadius.circular(20)` primary, `12` secondary
- Primary button: `#FF6B2B` orange (`PsoldColors.primary`)
- WhatsApp button (`#25D366`): only when `profile.role == 'client'`; number in E.164
- Skeleton loaders for loading states — never `CircularProgressIndicator` alone
- RTL-safe layout: `EdgeInsetsDirectional`, `TextAlign.start`

## Premium & Upload Limits

- **Free tier**: 5 images / 2 videos per day per merchant. `daily_image_count`, `daily_video_count`, `daily_reset_at` on `profiles` (reset each calendar day).
- **Premium** (`is_premium` flag): unlimited uploads. Upsell at `/premium` route.
- Limits enforced in `UserProfile` model methods (`canUploadImage`, `canUploadVideo`, `remainingImages`, `remainingVideos`).
- DB fields added in migrations `005_add_premium_fields.sql` and `006_add_daily_upload_fields.sql`.

## Database (Supabase/PostgreSQL)

Tables: `profiles` (extends `auth.users`), `products`, `likes`, `comments`, `notifications`. RLS on all.

`profiles` notable fields: `role` (merchant/client), `display_name`, `whatsapp`, `avatar_url`, `city`, `fcm_token`, `last_active`, `is_premium`, `daily_image_count`, `daily_video_count`, `daily_reset_at`, `premium_since`.

`products` notable: validation status (`validated`, `ai_score`, `rejection_reason`), expiry dates.

Auto-logout after 5 days inactivity (`shouldAutoLogout()` in `router.dart:182`).

## Supabase CLI

CLI at `supabase.exe` in project root. Requires access token from https://app.supabase.com/account/tokens.

| Task | Command |
|------|---------|
| Login | `supabase.exe login --token <token>` |
| Link project | `supabase.exe link --project-ref dsflswhxvjnvkedhrynd` |
| Push migrations | `supabase.exe db push --yes` |
| Run SQL | `supabase.exe db query --linked --file path/to/file.sql` |

**Migrations**: 6 existing (001-006). Never modify existing — add new as `007_<description>.sql`.

Edge Function at `supabase/functions/validate-product/index.ts` — runs on Deno, validates product expiry vs category limits.

## Key Source Files

| File | What |
|------|------|
| `SPEC.md` | Original specs, DB schema, design tokens, RLS, business rules |
| `PROGRESS.md` | Implementation checklist with file locations |
| `lib/core/router.dart` | Routes, guards, providers, `UserProfile` model |
| `lib/core/theme.dart` | Colors, spacing, text theme, light/dark themes |
| `lib/core/supabase_client.dart` | Supabase singleton init |
| `lib/core/constants.dart` | App thresholds (max images, OCR confidence, cache duration) |
| `lib/core/locale_provider.dart` | Hive-persisted locale (riverpod) |
| `lib/shared/providers/auth_provider.dart` | AuthNotifier (email + Google sign in/up) |
| `lib/shared/utils/google_auth_service.dart` | Google Sign-In service |

## Quirks

- `lib/l10n/` contains both ARB sources AND generated Dart files — actual runtime output is `lib/flutter_gen/gen_l10n/`. Edit only ARB files, then `flutter gen-l10n`.
- `lib/shared/widgets/_role_card.dart` is a private file exporting `RoleCard` class — do not move/rename.
- `lib/shared/widgets/_psold_scaffold.dart` defines `PsoldScaffold`/**`PsoldShell`** — **unused** (router uses `_NavScaffold` instead). Do not rely on it.
- All env vars via `--dart-define`. No `.env` loading at runtime, no `flutter_dotenv`.
- Splash: color-only (no image) in `flutter_native_splash.yaml`. Regenerate with `dart run flutter_native_splash:create`.
- CI via Codemagic (`codemagic.yaml`): android-debug, android-release, ios-release, pr-checks workflows.
- 4 test files in `test/`: `widget_test.dart`, `login_screen_test.dart`, `product_model_test.dart`, `product_card_test.dart`.
- `google_auth_service.dart` has `_webClientId` hardcoded — needed for Google Sign-In on Android.
