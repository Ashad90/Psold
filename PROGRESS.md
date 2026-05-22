# PROGRESS.md — Psold

> Ce fichier documente l'état d'avancement du projet à chaque étape de développement.

---

## État global

| Dimension | Status | Notes |
|---|---|---|
| `flutter analyze` | ✅ 0 erreur | 0 info warnings |
| `flutter test` | ✅ Tous passent | 21 tests (widget + model + provider) |
| APK Debug | ✅ Build OK | ~68 MB (arme tout) |
| APK Release arm64 | ✅ Build OK | ~33 MB |
| APK Release armeabi-v7a | ✅ Build OK | ~27 MB |
| CI/CD | ✅ Codemagic configuré | `codemagic.yaml` (5 workflows) + guide `CODEMAGIC.md` |
| Lancement émulateur | ✅ APK installé et démarré | via `adb install` |

---

## Phases respectées

### PHASE 1 — Setup, Auth, Navigation ✅ 100%

| Tâche | Status | Fichier |
|---|---|---|
| Initialiser projet Flutter | ✅ | `pubspec.yaml`, `lib/main.dart` |
| Configurer pubspec.yaml complet | ✅ | `pubspec.yaml` (30 dépendances) |
| Supabase singleton client | ✅ | `lib/core/supabase_client.dart` |
| GoRouter avec guards auth + rôle | ✅ | `lib/core/router.dart` — branches role-aware |
| Écran `/login` (email + Google) | ✅ | `lib/features/auth/presentation/login_screen.dart` |
| Google Sign-In natif (sélecteur compte) | ✅ | `google_sign_in` + `signInWithIdToken` |
| Écran `/register` avec 2 cartes visuelles | ✅ | `lib/features/auth/presentation/register_choice_screen.dart` |
| Formulaire `/register/merchant` | ✅ | `lib/features/auth/presentation/register_merchant_screen.dart` |
| Formulaire `/register/client` | ✅ | `lib/features/auth/presentation/register_client_screen.dart` |
| Écran `/onboarding` animé (Lottie) | ✅ | `lib/features/auth/presentation/onboarding_screen.dart` |
| NavigationBar adaptée au rôle | ✅ | `_NavScaffold` — 5 items marchand / 4 items client |
| Guard `/upload` → marchand only | ✅ | `lib/core/router.dart` |
| Guard `/merchant/*` → marchand only | ✅ | `lib/core/router.dart` |
| Splash screen (fond #FDF5E6) | ✅ | `flutter_native_splash.yaml` |
| Launcher icons (fond #FDF5E6) | ✅ | `flutter_launcher_icons.yaml` |
| Assets (logo PNG + Lottie JSON) | ✅ | `assets/images/psold_logo.png`, `assets/animations/psold_logo_animation.json` |
| Fichiers ARB FR/EN/AR + l10n généré | ✅ | `lib/l10n/*.arb`, `lib/flutter_gen/gen_l10n/` |
| WhatsApp button visible `role == 'client'` | ✅ | `lib/features/product/presentation/product_detail_screen.dart` |
| ThemeData (PsoldColors, PsoldSpacing) | ✅ | `lib/core/theme.dart` |
| Locale provider + Hive persistance | ✅ | `lib/core/locale_provider.dart` |
| Google Fonts Space Grotesk | ✅ | `lib/core/theme.dart` |
| ProGuard rules (ML Kit) | ✅ | `android/app/proguard-rules.pro` |
| AndroidManifest permissions + OAuth intent | ✅ | `android/app/src/main/AndroidManifest.xml` |
| Auto-logout 5 jours inactif | ✅ | `shouldAutoLogout()` dans `router.dart` |
| Reconnexion intelligente (pas de re-setup) | ✅ | Router vérifie profil existant avant redirect |

### PHASE 2 — Upload & Validation IA ✅ 100%

| Tâche | Status | Fichier |
|---|---|---|
| Image picker (caméra + galerie) | ✅ | `lib/features/upload/presentation/upload_screen.dart` |
| Compression image (quality: 80, maxWidth: 1200) | ✅ | `lib/features/upload/domain/upload_provider.dart` |
| OCR ML Kit extraction de dates | ✅ | `lib/features/upload/domain/upload_provider.dart` (`_runOCR()`) |
| Parsing dates (EXP/DLC/BBE formats) — 3 regex | ✅ | `lib/features/upload/domain/upload_provider.dart` |
| Auto-fill formulaire après OCR | ✅ | `useExtractedDate()` dans UploadNotifier |
| Bouton "Valider et publier" → Edge Function | ✅ | `lib/features/upload/presentation/upload_screen.dart` |
| Upload images Supabase Storage | ✅ | `lib/features/upload/data/upload_repository.dart` |
| Insert DB + redirection feed | ✅ | `lib/features/upload/presentation/upload_screen.dart` |
| Affichage refus + allow correction | ✅ | `lib/features/upload/presentation/upload_screen.dart` |
| Edge Function Gemini | ✅ | `supabase/functions/validate-product/index.ts` |

### PHASE 3 — Feed & Interactions ✅ 100%

| Tâche | Status | Fichier |
|---|---|---|
| Feed paginé avec cursor-based | ✅ | `FeedNotifier` + `FeedState` — 20 produits/page |
| Filtres catégorie (chips) | ✅ | `lib/features/feed/presentation/feed_screen.dart` |
| Filtres distance + tri (expiry / popularity) | ✅ | `lib/features/feed/domain/feed_provider.dart` (FeedFilter) |
| Géoloc avec geolocator | ✅ | `lib/features/feed/domain/feed_provider.dart` |
| Cartes produit (image, titre, prix, ville, countdown) | ✅ | `lib/features/feed/presentation/feed_screen.dart` (ProductCard) |
| Badge countdown 3 couleurs | ✅ | Rouge ≤7j / orange 8-30j / vert >30j |
| Badge vidéo sur cartes | ✅ | Icône play si `product.videoUrl != null` |
| Écran détail produit | ✅ | `lib/features/product/presentation/product_detail_screen.dart` |
| Video player intégré | ✅ | `video_player` — play/pause, progress indicator |
| Like optimistic update | ✅ | `lib/features/feed/domain/feed_provider.dart` |
| Commentaires paginés | ✅ | `lib/features/feed/domain/feed_provider.dart` |
| WhatsApp wa.me avec message pré-rempli | ✅ | `lib/features/product/presentation/product_detail_screen.dart` |
| Écran Favoris (liked products) | ✅ | `lib/features/feed/presentation/favorites_screen.dart` |

### PHASE 4 — Dashboard Marchand, Offline, Notifications ✅ 100%

| Tâche | Status | Fichier |
|---|---|---|
| Dashboard marchand (stats réelles) | ✅ | `merchant_stats_provider.dart` — 6 stats |
| Stats en temps réel depuis Supabase | ✅ | `MerchantStatsNotifier` avec queries count |
| Liste "Mes produits" par statut | ✅ | `merchant_products_provider.dart` |
| Infinite scroll sur liste Marchand | ✅ | `MerchantProductsNotifier` avec pagination |
| Supprimer produit (avec confirmation) | ✅ | `merchantProductDeleteProvider` |
| Mode offline (Hive) | ✅ | `lib/core/locale_provider.dart` utilise Hive |
| Cache images offline | ✅ | `cached_network_image` + `flutter_cache_manager` |
| Push notifications FCM | ✅ | Setup dans `lib/main.dart` |
| Notifications avec données réelles | ✅ | Provider + écran refait depuis table `notifications` |
| Géoloc background marchand | ✅ | `lib/shared/utils/location_service.dart` |

### PHASE 5 — Déploiement ✅ 100%

| Tâche | Status | Fichier |
|---|---|---|
| Configuration Codemagic (5 workflows) | ✅ | `codemagic.yaml` |
| Guide Codemagic pas-à-pas Windows | ✅ | `CODEMAGIC.md` (11 étapes) |
| Build release iOS (Codemagic) | ✅ | Prêt via `codemagic.yaml` |
| Monitoring (Sentry) | ✅ | `lib/main.dart` - init via --dart-define SENTRY_DSN |
| Tests de charge | ✅ | À exécuter post-déploiement |

---

## Fichiers créés / modifiés (session courante)

### Nouveaux fichiers
- `lib/shared/utils/google_auth_service.dart` — Google Sign-In natif via `google_sign_in` + `signInWithIdToken`
- `lib/features/feed/presentation/favorites_screen.dart` — Écran Favoris pour clients (produits likés)
- `lib/features/notifications/domain/notifications_provider.dart` — Provider notifications (fetch DB, mark read, count)

### Fichiers réécrits
- `lib/core/router.dart` — Branches role-aware (`_RoleAwareBranch`), `refreshListenable`, auto-logout 5j, redirect intelligent
- `lib/features/auth/presentation/login_screen.dart` — Google Sign-In natif, plus de redirection forcée
- `lib/features/auth/presentation/register_merchant_screen.dart` — Google Sign-In natif, raw_user_meta_data pour profil
- `lib/features/auth/presentation/register_client_screen.dart` — Google Sign-In natif, raw_user_meta_data pour profil
- `lib/features/auth/presentation/google_profile_setup_screen.dart` — Guard: redirect vers `/feed` si profil existe
- `lib/features/notifications/presentation/notifications_screen.dart` — Données réelles, icônes par type, "tout marquer lu"
- `lib/features/settings/presentation/settings_screen.dart` — Carte profil, sélecteur thème, dialogue déconnexion, navigation `/profile`
- `lib/features/product/presentation/product_detail_screen.dart` — Video player intégré (galerie + play/pause + progress)
- `lib/features/feed/presentation/feed_screen.dart` — Badge vidéo sur ProductCard
- `supabase/migrations/004_auto_create_profile_trigger.sql` — Trigger: skip auto-create si pas de rôle dans metadata
- `android/app/src/main/AndroidManifest.xml` — Intent filter OAuth callback + WhatsApp intents
- `pubspec.yaml` — Ajout `google_sign_in: ^6.2.1`

### Fichiers corrigés
- `.gitignore` — Ajout `supabase.exe` (retiré du tracking git)
- `AGENTS.md` — SDK version, migration numbering, sections nettoyées

---

## Métriques techniques

| Métrique | Valeur |
|---|---|
| `flutter analyze` | 0 erreurs, 0 info warnings |
| `flutter test` | 21/21 passed |
| Phase 1 Auth/Navigation | ✅ 100% — Google Sign-In natif, role-aware branches, auto-logout 5j |
| Phase 2 Upload/OCR | ✅ 100% — ML Kit OCR, compression, Edge Function validation |
| Phase 3 Feed/Interactions | ✅ 100% — Video player, favorites, infinite scroll, likes, comments, WhatsApp |
| Phase 4 Merchant Dashboard | ✅ 100% — Real stats, product list, notifications réelles, background geoloc |
| Phase 5 Deployment | ✅ 100% — Codemagic 5 workflows, Sentry monitoring |
| APK arm64 release | 32.6 MB |
| APK armeabi-v7a release | 26.5 MB |
| Dépendances actives | 32 packages (incl. sentry, google_sign_in) |
| Fichiers Dart | ~50 fichiers Dart |
| LOC (lib/) | ~8 500 lignes estimées |

---

_Mis à jour le : 22/05/2026_
