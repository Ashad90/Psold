# AGENTS.md — Psold

## Essential Commands

| Task | Command |
|------|---------|
| Lint/typecheck | `flutter analyze` |
| Run tests | `flutter test` |
| Run specific test | `flutter test test/widget_test.dart` |
| Generate localization | `flutter gen-l10n` |
| Code generation (after riverpod/freezed/json) | `flutter pub run build_runner build` |
| Watch & regenerate | `flutter pub run build_runner watch` |
| Clean rebuild | `flutter clean && flutter pub get` |
| Build debug APK | `flutter build apk --debug` |

**Command order**: `flutter analyze` before `flutter test` to catch type errors early.

## Critical Constraints

- **Size limit**: App must be <15MB (target 10MB). Avoid large dependencies.
- **Performance**: Cold-start must be <1s on mid-range devices.
- **Role separation**: Never give clients merchant capabilities or vice versa. Hard rule.

## Architecture

- Entry point: `lib/main.dart` with `ProviderScope` + GoRouter + Firebase init
- State: Riverpod 2.x with `@riverpod` annotations (run `build_runner` after adding)
- Navigation: GoRouter with auth/role guards in `lib/core/router.dart`
- Auth flow: Google users → `/google-profile-setup` → `/onboarding` → `/feed`; email users → `/onboarding` → `/feed`
- Auto-logout after 7 days inactive (checked in router redirect via `shouldAutoLogout()`)
- Theme: Use `PsoldColors` and `PsoldSpacing` from `lib/core/theme.dart` — never hardcode colors/spacing
- RTL: Use `EdgeInsetsDirectional`, `TextAlign.start`, `Directionality.of(context)` — don't assume LTR
- Supabase client: singleton in `lib/core/supabase_client.dart` — init via `--dart-define` env vars (`SUPABASE_URL`, `SUPABASE_ANON_KEY`)
- Fonts: Space Grotesk via `google_fonts` package (loaded at runtime — no bundled fonts)

## Key Sources

- **SPEC.md**: Full product specs, DB schema, design tokens, RLS policies, business rules — **read before any task**
- **START_HERE.md**: 25-phase task workflow, skill activation, execution sequence
- **lib/core/**: Real entrypoints — `router.dart` (routes, guards), `theme.dart` (colors/spacing), `supabase_client.dart`, `locale_provider.dart`
- **lib/l10n/**: ARB files (app_fr.arb, app_en.arb, app_ar.arb) — localization auto-generated via `flutter: generate: true`

## Directory Layout

```
lib/
├── main.dart                  # Entry point
├── core/                      # supabase_client, router, theme, locale_provider, constants
├── features/                  # auth, feed, upload, product, merchant, search, notifications, settings
├── shared/                    # widgets, models, utils
├── l10n/                      # ARB files
└── flutter_gen/               # generated l10n code (do not edit)
```

## Supabase CLI

Le CLI est dans `supabase.exe` à la racine du projet. Prérequis : token d'accès sur https://app.supabase.com/account/tokens.

| Task | Command |
|------|---------|
| Se connecter | `supabase.exe login --token <token>` |
| Lier le projet | `supabase.exe link --project-ref dsflswhxvjnvkedhrynd` |
| Push migrations | `supabase.exe db push --yes` |
| Requête SQL | `supabase.exe db query --linked --file path/to/file.sql` |

**Attention** : Ne jamais modifier les migrations existantes (001_initial_schema.sql) — le remote a déjà le schéma. Ajouter uniquement de nouvelles migrations numérotées (003_...).

## Setup Requirements

1. Run `flutter pub get` before building
2. After adding packages that use code gen (riverpod_annotation, freezed, json_serializable), run `flutter pub run build_runner build`
3. After adding new ARB files, run `flutter gen-l10n`
4. Supabase credentials via `--dart-define` — fallback to hardcoded dev values in `supabase_client.dart` for local dev only
5. Hive box `'settings'` must be opened before `runApp` (done in `main.dart`)

## Design Rules

- All spacing: multiples of 8px (`PsoldSpacing.xs=4` through `PsoldSpacing.xxxl=64`)
- Cards: `BorderRadius.circular(20)` for primary, `12` for secondary elements
- Primary button: `#FF6B2B` orange, height 56px min
- WhatsApp button (`#25D366`): **only visible when `profile.role == 'client'`**
- Skeleton loaders for loading states — never `CircularProgressIndicator` alone
- WhatsApp number: format E.164 (`+[country][number]`)

## Navigation Bar

- **Client**: Accueil | Favoris | Alertes | Paramètres
- **Merchant**: Accueil | Publier | Mes produits | Alertes | Paramètres
- Role-based nav rendered in `_NavScaffold` (`lib/core/router.dart:158`)

## Testing Notes

- Tests live in `test/` directory
- Run `flutter analyze` before `flutter test` to catch type errors early

## Available Skills

Activate with `use <skill-name>` before task-specific work:

| Skill | Use For |
|-------|---------|
| `flutter-expert` | State management, navigation, SDK integration, performance |
| `mobile-design` | UI/UX, widgets, animations, theming, mobile design patterns |
| `fullstack-developer` | Database, backend, Edge Functions, CI/CD |

## Quirks

- `_role_card.dart` in `shared/widgets/` is a private file imported as `RoleCard` — do not move or rename
- Assets: `assets/images/` and `assets/animations/` (defined in pubspec.yaml)
- Notification service singleton via `notificationServiceProvider` in `shared/utils/notification_service.dart`
- Dark theme available via `psoldDarkTheme` in `lib/core/theme.dart`
- App language: French market (FR/EN/AR support)
- Sentry DSN is optional — set via `SENTRY_DSN` env var (defaults to empty/disabled)