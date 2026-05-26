# AGENTS.md — Psold

Flutter marketplace app (merchant/client roles). Supabase backend, Riverpod state, GoRouter navigation.

## Commands

| Task | Command |
|------|---------|
| Lint/typecheck | `flutter analyze` |
| All tests | `flutter test` |
| Single test | `flutter test test/<file>` |
| Goldens | `flutter test --update-goldens` |
| Locale codegen | `flutter gen-l10n` |
| Riverpod/freezed/json codegen | `flutter pub run build_runner build` |
| Watch codegen | `flutter pub run build_runner watch` |
| Clean rebuild | `flutter clean && flutter pub get` |
| Splash (one-time) | `dart run flutter_native_splash:create` |
| Icons (one-time) | `dart run flutter_launcher_icons` |
| Build release APK (dev) | `flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=GOOGLE_CLIENT_ID=...` |

**Order**: `build_runner` → `flutter analyze` → `flutter test`. Run `build_runner` after adding `@riverpod`/`freezed`/`json_serializable`.

**SDK**: Dart `^3.11.5`. Package imports use `package:psold/...`.

## Entrypoint

`lib/main.dart`: Hive box `'settings'` opened before `runApp`. Firebase init + Sentry (opt-in via `--dart-define=SENTRY_DSN=<dsn>`). `debugShowCheckedModeBanner: false`.

## Architecture

- **Auth**: Supabase Auth (email + Google Sign-In). Google flow → `/google-profile-setup` → `/onboarding` → `/feed`. Email flow → `/onboarding` → `/feed`. Auth logic in `lib/shared/providers/auth_provider.dart` (StateNotifier).
- **State**: Riverpod 2.x with `@riverpod` annotations. Core providers in `lib/core/router.dart`: `supabaseClientProvider`, `authStateProvider`, `currentUserProvider` (Notifier with `UserProfile`), `merchantBackgroundLocationProvider`.
- **Navigation**: GoRouter with auth/role redirects in `lib/core/router.dart`. `_NavScaffold` + `_RoleAwareBranch` for role-aware shell. 5 `StatefulShellBranch` entries — branch indices = nav bar items. `/feed` route uses `FeedScreenWrapper` (sets `isMerchant` prop on `FeedScreen`).
- **Theme**: `PsoldColors`, `PsoldSpacing` from `lib/core/theme.dart` — never hardcode. Material3 enabled. Light + dark themes.
- **RTL**: `EdgeInsetsDirectional`, `TextAlign.start`, `Directionality.of(context)`. Supported locales: fr (default), en, ar.
- **Supabase**: Singleton at `lib/core/supabase_client.dart`. Init via `--dart-define` OR falls back to hardcoded dev values (safe — anon key with RLS). No `.env` at runtime.
- **Fonts**: Space Grotesk via `google_fonts` (runtime).
- **Sentry**: Optional, `--dart-define=SENTRY_DSN=<dsn>` (disabled by default).

## Nav bar tabs (per role)

| Tab | Merchant | Client |
|-----|----------|--------|
| 0 | Accueil | Accueil |
| 1 | Publier | Favoris |
| 2 | Mes produits | Alertes |
| 3 | Alertes | Paramètres |
| 4 | Paramètres | — |

## Design rules

- Spacing: multiples of 8px (`PsoldSpacing.xs=4` to `xxxl=64`).
- Cards: `BorderRadius.circular(20)` primary, `12` secondary.
- Primary button: `#FF6B2B` (`PsoldColors.primary`).
- WhatsApp button (`#25D366`): only when `role == 'client'`; number in E.164.
- Skeleton loaders for loading states — never `CircularProgressIndicator` alone.

## Upload limits

- **Free tier**: 5 images / 2 videos per day per merchant. Fields on `profiles`: `daily_image_count`, `daily_video_count`, `daily_reset_at` (reset each calendar day).
- **Premium** (`is_premium`): unlimited. Upsell at `/premium`.
- Enforced in `UserProfile` methods: `canUploadImage`, `canUploadVideo`, `remainingImages`, `remainingVideos`.

## Database (Supabase/PostgreSQL)

Tables: `profiles` (extends `auth.users`), `products`, `likes`, `comments`, `notifications`. RLS on all. Migrations 001-006 in `supabase/migrations/`. Never modify existing — add `007_<description>.sql`.

Notable profile fields: `role`, `display_name`, `whatsapp`, `avatar_url`, `city`, `fcm_token`, `last_active`, `is_premium`, `daily_image_count`, `daily_video_count`, `daily_reset_at`, `premium_since`.

Products: validation status (`validated`, `ai_score`, `rejection_reason`), expiry dates.

Auto-logout after 5 days inactivity (`shouldAutoLogout()` in `router.dart:182`).

## Supabase CLI

`supabase.exe` at root (gitignored). Needs token from https://app.supabase.com/account/tokens.

| Task | Command |
|------|---------|
| Login | `supabase.exe login --token <token>` |
| Link project | `supabase.exe link --project-ref dsflswhxvjnvkedhrynd` |
| Push migrations | `supabase.exe db push --yes` |
| Run SQL | `supabase.exe db query --linked --file path/to/file.sql` |

3 Edge Functions in `supabase/functions/`: `validate-product` (Deno, validates product expiry vs category limits), `create-checkout` (Stripe checkout), `stripe-webhook` (payment events).

## Key files

| File | What |
|------|------|
| `SPEC.md` | Original specs, DB schema, design tokens, RLS, business rules |
| `PROGRESS.md` | Implementation checklist with file locations |
| `CLAUDE.md` | Sibling agent instructions (overlapping content) |
| `CODEMAGIC.md` | CI/CD setup guide (Windows, 11 steps) |
| `lib/core/router.dart` | Routes, guards, providers, `UserProfile` model |
| `lib/core/theme.dart` | Colors, spacing, text theme, light/dark themes |
| `lib/core/supabase_client.dart` | Supabase singleton init |
| `lib/core/constants.dart` | App thresholds (max images, OCR confidence, cache duration) |
| `lib/core/locale_provider.dart` | Hive-persisted locale (riverpod) |
| `lib/shared/providers/auth_provider.dart` | AuthNotifier (email + Google sign in/up) |
| `lib/shared/utils/google_auth_service.dart` | Google Sign-In service |
| `lib/features/feed/domain/feed_provider.dart` | `Product` model, `FeedFilter`, `FeedState`, feed query logic |

## Quirks

- `lib/l10n/` has both ARB sources AND generated Dart files — actual runtime output is `lib/flutter_gen/gen_l10n/`. Edit only ARB files, then `flutter gen-l10n`.
- `lib/shared/widgets/_role_card.dart` is private but exports `RoleCard` — do not move/rename.
- `lib/shared/widgets/_psold_scaffold.dart` (`PsoldScaffold`/`PsoldShell`) — **unused** (router uses `_NavScaffold`). Do not rely on it.
- `lib/features/splash/presentation/splash_screen.dart` exists but is **not referenced** in the router — orphan.
- All env vars via `--dart-define`. No `.env` loading at runtime, no `flutter_dotenv`.
- `.env` at root contains live secrets (service role key, Gemini API key) — never commit.
- Splash: color-only in `flutter_native_splash.yaml`. Regenerate with `dart run flutter_native_splash:create`.
- CI via Codemagic (`codemagic.yaml`): 5 workflows (android-debug, android-release, **android-arm32**, ios-release, pr-checks).
- `google_auth_service.dart` has `_webClientId` hardcoded — needed for Google Sign-In on Android.
- 4 test files, ~21 tests total: `widget_test.dart`, `login_screen_test.dart`, `product_model_test.dart`, `product_card_test.dart`.
- Generated files (`*.g.dart`) live alongside sources — run `build_runner` after editing annotated files.
