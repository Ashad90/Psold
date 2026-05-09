# AGENTS.md — Psold

## Essential Commands

| Task | Command |
|------|---------|
| Lint/typecheck | `flutter analyze` |
| Run tests | `flutter test` |
| Run specific test | `flutter test test/widget_test.dart` |
| Code generation | `flutter pub run build_runner build` |
| Watch & regenerate | `flutter pub run build_runner watch` |
| Generate i18n | `flutter gen-l10n` |
| Clean rebuild | `flutter clean && flutter pub get` |
| Build debug APK | `flutter build apk --debug` |

## Critical Constraints

- **Size limit**: App must be <15MB (target 10MB). Avoid large dependencies.
- **Performance**: Cold-start must be <1s on mid-range devices.
- **Role separation**: Never give clients merchant capabilities or vice versa. Hard rule.

## Architecture

- Entry point: `lib/main.dart` with ProviderScope + GoRouter
- State: Riverpod 2.x with `@riverpod` annotations
- Navigation: GoRouter with auth/role guards
- Theme: Use `PsoldColors` and `PsoldSpacing` from `lib/core/theme.dart` — never hardcode colors/spacing
- RTL: Use `EdgeInsetsDirectional`, `TextAlign.start`, `Directionality.of(context)` — don't assume LTR

## Key Sources

- **START_HERE.md**: Step-by-step workflow with 25 phases. Read before any task.
- **CLAUDE.md**: Full architecture docs, patterns, and conventions.
- **SPEC.md**: Complete specs including colors, database schema, design system.
- **codemagic.yaml**: CI/CD pipelines for Android/iOS builds.
- **lib/l10n/**: ARB files for FR/EN/AR. Run `flutter gen-l10n` after editing.

## Skills

Use `flutter-expert` skill for architecture, logic, state management, and SDK work. Use `ui-ux-pro-max` skill for UI/UX screens and design.

## Setup Requirements

1. Run `flutter pub get` before building
2. If adding packages, run `flutter pub run build_runner build` to generate code
3. Supabase credentials must use `--dart-define` or Edge Functions — never in client code

## Directory Layout

```
lib/
├── main.dart
├── core/           # supabase_client, router, theme, constants, locale_provider
├── features/       # auth, feed, upload, product, merchant, search, notifications, settings
├── shared/         # widgets, models, providers, utils
├── l10n/           # ARB files (app_fr.arb, app_en.arb, app_ar.arb)
└── flutter_gen/    # generated l10n code (do not edit)
```

## Testing Notes

- Tests in `test/` directory
- Run `flutter analyze` before `flutter test` to catch type errors early

## Quirks

- WhatsApp button (`#25D366`) only visible for `role == 'client'`
- All spacing must be multiples of 8px
- Corner radius: 20px for cards, 12px for secondary elements
- Private file `_role_card.dart` in `shared/widgets/` is actually used as `RoleCard` — do not move or rename
- `l10n.yaml` does not exist; l10n driven by `pubspec.yaml` `flutter: generate: true` + ARB files in `lib/l10n/`
- Assets go in `assets/images/` and `assets/animations/` (defined in pubspec.yaml)
- Supabase client singleton in `lib/core/supabase_client.dart`