# PROMPT ENGINEERING — "Psold" MVP (Claude Code / OpenCode / Codex)

---

## ROLE & MISSION

Tu es un ingénieur senior full-stack mobile spécialisé Flutter/Dart + Firebase/Supabase & Python.
Tu dois construire le MVP complet de **Psold**, une marketplace mobile sociale
ciblant l'Afrique francophone (Bangui / République Centrafricaine en priorité).

**Règle absolue** : chaque interaction utilisateur doit répondre en **<1 secondes**.
Toute décision d'architecture doit servir cette contrainte.

---

## CONTEXTE PRODUIT

**Psold**, application Mobile Lite (par ce que cette application ne doit en aucun cas peser plus de 15mb, elle doit peser au maximum 10mb) qui connecte des **marchands** (supermarchés, grossistes) à des **clients**
sur des produits soldés ou proches de leur date de péremption.

- Les marchands uploadent photos/vidéos de leurs produits + métadonnées (via leur propre librarie ou gallerie de smartphone).
- Une IA valide automatiquement l'éligibilité (dates, qualité, catégorie).
- Les clients browsent un feed géolocalisé, likent, commentent, contactent via WhatsApp.
- Monétisation : freemium (uploads limités en gratuit, illimités en premium).

**Cibles prioritaires** : marchands et clients en zone urbaine avec connexion 3G/4G instable.
L'app doit fonctionner en mode offline partiel (cache du feed).

---

## STACK TECHNOLOGIQUE — VERSIONS EXACTES

| Couche | Technologie | Version |
|---|---|---|
| Mobile | Flutter | 3.27+ (Dart 3.x) |
| State management | Riverpod | 2.x (avec `@riverpod` annotations) |
| Backend / BaaS | Supabase | dernière stable |
| Base de données | PostgreSQL (via Neon DB) | — |
| Stockage fichiers | Cloudinary Storage | — |
| Auth | Supabase Auth (email + phone OTP) | — |
| OCR on-device | Google ML Kit — Text Recognition | dernière stable |
| IA cloud | Gemini API | via Supabase Edge Functions |
| Push notifications | Firebase Cloud Messaging (FCM) | — |
| CI/CD | Codemagic | — |
| Rendu moteur | Flutter Impeller | activé par défaut sur iOS, activé en opt-in Android |

**Contrainte budget** : Supabase free tier + Firebase Spark plan pour le MVP.
Coût cible < 100 €/mois à 1 000 utilisateurs actifs.

---

## DESIGN SYSTEM & COULEURS

### Palette officielle Psold

| Rôle | Valeur | Usage |
|---|---|---|
| `backgroundLight` | `#FDF5E6` | Background général — thème clair |
| `backgroundDark` | `#000000` | Background général — thème sombre |
| `navBarActiveBackground` | `rgb(225, 224, 225)` → `#E1E0E1` | Background de l'icône active dans la NavigationBar |

### Code Flutter — `lib/core/theme.dart`

```dart
import 'package:flutter/material.dart';

// ─── Tokens de couleur ───────────────────────────────────────────────────────
class PsoldColors {
  PsoldColors._()

  static const Color backgroundLight       = Color(0xFFFDF5E6);
  static const Color backgroundDark        = Color(0xFF000000);
  static const Color navBarActiveIndicator = Color(0xFFE1E0E1) si white et (0x000120) si black;
}

// ─── Thème clair ─────────────────────────────────────────────────────────────
final ThemeData psoldLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: PsoldColors.backgroundLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: PsoldColors.backgroundLight,
    brightness: Brightness.light,
    surface: PsoldColors.backgroundLight,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: PsoldColors.backgroundLight,
    indicatorColor: PsoldColors.navBarActiveIndicator,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  useMaterial3: true,
);

// ─── Thème sombre ─────────────────────────────────────────────────────────────
final ThemeData psoldDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: PsoldColors.backgroundDark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: PsoldColors.backgroundDark,
    brightness: Brightness.dark,
    surface: PsoldColors.backgroundDark,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: PsoldColors.backgroundDark,
    indicatorColor: PsoldColors.navBarActiveIndicator,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  useMaterial3: true,
);
```

### Utilisation dans `main.dart`

```dart
MaterialApp.router(
  title: 'Psold',
  theme: psoldLightTheme,
  darkTheme: psoldDarkTheme,
  themeMode: ThemeMode.system, // suit le mode OS de l'utilisateur
  routerConfig: router,
);
```

### Règles de cohérence visuelle

- **Jamais** de couleur codée en dur dans les widgets → toujours `Theme.of(context).colorScheme.*` ou `PsoldColors.*`
- Le `scaffoldBackgroundColor` est la source de vérité pour le fond de chaque écran — ne pas override au niveau widget sauf exception documentée
- L'indicateur actif de la `NavigationBar` utilise exclusivement `#E1E0E1` dans le thème white et utilise `#000120` dans le thème black

---

## ASSETS, SPLASH SCREEN & LAUNCHER ICON

### Emplacement des fichiers assets

```
psold/
├── assets/
│   ├── images/
│   │   └── psold_logo.png          # Logo officiel (fourni — NE PAS RÉGÉNÉRER)
│   └── animations/
│       └── psold_logo_animation.json  # Animation Lottie du logo (voir section dédiée)
```

Déclarer dans `pubspec.yaml` :

```yaml
flutter:
  generate: true
  assets:
    - assets/images/
    - assets/animations/
```

---

### Splash Screen — `flutter_native_splash`

Créer `flutter_native_splash.yaml` à la racine du projet :

```yaml
flutter_native_splash:
  color: "#FDF5E6"
  image: assets/images/psold_logo.png
  color_dark: "#FDF5E6"
  image_dark: assets/images/psold_logo.png
  android_12:
    image: assets/images/psold_logo.png
    color: "#F0000"
    image_dark: assets/images/psold_logo.png
    color_dark: "#F0000"
  web: false
```

Commande de génération (à lancer une fois) :

```bash
dart run flutter_native_splash:create
```

---

### Launcher Icon — `flutter_launcher_icons`

Créer `flutter_launcher_icons.yaml` à la racine :

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/psold_logo.png"
  adaptive_icon_background: "#FDF5E6"
  adaptive_icon_foreground: "assets/images/psold_logo.png"
  min_sdk_android: 21
  web:
    generate: false
```

Commande de génération :

```bash
dart run flutter_launcher_icons
```

---

### Onboarding Screen — Animation Lottie (2s max)

Utiliser le fichier `assets/animations/psold_logo_animation.json` avec le package `lottie`.

```dart
import 'package:lottie/lottie.dart';

class OnboardingLogoWidget extends StatefulWidget {
  const OnboardingLogoWidget({super.key});

  @override
  State<OnboardingLogoWidget> createState() => _OnboardingLogoWidgetState();
}

class _OnboardingLogoWidgetState extends State<OnboardingLogoWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/psold_logo_animation.json',
      controller: _controller,
      width: 200,
      height: 200,
      repeat: false,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration  // exactement 2s (60 frames @ 30fps)
          ..forward();
      },
    );
  }
}
```

Structure de l'écran Onboarding complet :

```dart
Scaffold(
  backgroundColor: const Color(0xFFFDF5E6),  // fond crème
  body: SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        const OnboardingLogoWidget(),           // animation Lottie logo
        const SizedBox(height: 24),
        Text(
          'Psold',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.tagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF666666),
          ),
        ),
        const Spacer(flex: 3),
        // Boutons langue + démarrage...
      ],
    ),
  ),
)
```

---

## ARCHITECTURE — STRUCTURE DU PROJET

```
psold/
├── lib/
│   ├── main.dart                  # Entrypoint, ProviderScope, GoRouter init
│   ├── core/
│   │   ├── supabase_client.dart   # Singleton Supabase init
│   │   ├── router.dart            # GoRouter avec guards auth
│   │   ├── theme.dart             # ThemeData centralisé
│   │   └── constants.dart         # URLs, seuils péremption, etc.
│   ├── features/
│   │   ├── auth/  
│   │   ├──-- sellers/              # Login, register, profil (merchents)
│   │   ├──-- clients/              # Login, register, profil
│   │   ├── feed/                  # Feed produits, filtres, géoloc
│   │   ├── upload/                # Caméra, OCR, formulaire, validation IA (only merchents)
│   │   ├── product/               # Détail produit, likes, commentaires (only clients)
│   │   ├── search/                # Recherche des produits par le nom de ces produit, le nom du Supermarket, Magasin, Boutique (SEO)
│   │   ├── merchant/              # Dashboard marchand, stats (uploads products there)
│   │   └── notifications/         # Push notifications
│   └── shared/
│       ├── widgets/               # Composants réutilisables
│       ├── models/                # Classes Dart (freezed + json_serializable)
│       └── utils/                 # Helpers dates, formatage, WhatsApp intent
├── supabase/
│   ├── migrations/                # SQL migrations versionnées
│   └── functions/                 # Edge Functions Deno (IA Gemini)
├── pubspec.yaml
└── README.md
```

**Pattern par feature** : chaque feature contient `data/` (repositories),
`domain/` (models, providers Riverpod), `presentation/` (screens, widgets).

---

## SCHÉMA BASE DE DONNÉES (PostgreSQL / Supabase)

```sql
-- Activer les extensions nécessaires
create extension if not exists "postgis";   -- géolocalisation
create extension if not exists "uuid-ossp";

-- Utilisateurs (enrichit auth.users de Supabase)
create table public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  role         text not null check (role in ('merchant', 'client')),
  display_name text not null,
  whatsapp     text,                   -- obligatoire pour les marchands
  avatar_url   text,
  location     geography(point, 4326), -- coordonnées GPS
  city         text,
  created_at   timestamptz default now()
);

-- Produits
create table public.products (
  id            uuid primary key default uuid_generate_v4(),
  merchant_id   uuid not null references public.profiles(id) on delete cascade,
  title         text not null,
  description   text,
  category      text not null check (category in ('alimentaire', 'electronique', 'cosmetique', 'autre')),
  price_original numeric(10,2),
  price_promo    numeric(10,2) not null,
  expiry_date    date not null,
  quantity       integer default 1,
  images         text[] default '{}',  -- URLs Supabase Storage
  video_url      text,
  location       geography(point, 4326),
  city           text,
  validated      boolean default false,
  ai_score       numeric(4,2),         -- score confiance IA 0-1
  rejection_reason text,
  views_count    integer default 0,
  created_at     timestamptz default now(),
  expires_at     timestamptz            -- calculé : expiry_date + 1 jour
);

-- Likes
create table public.likes (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz default now(),
  unique(user_id, product_id)
);

-- Commentaires
create table public.comments (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  content    text not null,
  created_at timestamptz default now()
);

-- Row Level Security
alter table public.profiles  enable row level security;
alter table public.products  enable row level security;
alter table public.likes     enable row level security;
alter table public.comments  enable row level security;

-- Policies (exemples clés)
create policy "Profils publics en lecture"
  on public.profiles for select using (true);

create policy "Marchands gèrent leurs produits"
  on public.products for all
  using (merchant_id = auth.uid());

create policy "Produits validés visibles par tous"
  on public.products for select
  using (validated = true or merchant_id = auth.uid());

create policy "Likes par utilisateurs connectés"
  on public.likes for insert
  with check (auth.uid() is not null);
```

---

## RÈGLES MÉTIER IA (VALIDATION PRODUIT)

### Étape 1 — OCR on-device (ML Kit, < 1s)

- Scanner images/première frame vidéo pour extraire texte
- Reconnaître formats de dates variés :
  - `EXP 25DEC24`, `DLC 25/12/2024`, `BBE 25.12.24`, `BEST BEFORE DEC 2024`
- Retourner un objet structuré : `{ expiry_date: "2024-12-25", confidence: 0.95 }`
- Si confidence < 0.7 → proposer saisie manuelle à l'utilisateur

### Étape 2 — Validation cloud (Gemini via Edge Function, < 1s)

```
Endpoint : POST /functions/v1/validate-product

Input :
{
  "category": "alimentaire" | "electronique" | "cosmetique" | "autre",
  "expiry_date": "2024-12-25",
  "images_urls": ["https://..."],
  "title": "Boîte de sardines Marca",
  "today": "2024-10-01"
}

Règles d'éligibilité :
- alimentaire   : 1 jour ≤ délai_restant ≤ 90 jours
- cosmetique    : 1 jour ≤ délai_restant ≤ 120 jours
- electronique  : pas de contrainte date (mais date requise si applicable)
- autre         : 1 jour ≤ délai_restant ≤ 90 jours

Output :
{
  "validated": true | false,
  "ai_score": 0.0–1.0,
  "rejection_reason": "Date trop lointaine (> 3 mois)" | null,
  "extracted_info": { "brand": "...", "weight": "..." }
}
```

---

## FONCTIONNALITÉS — IMPLÉMENTATION PAR PHASE

---

## ⚠️ AUTHENTIFICATION — DEUX TYPES DE COMPTES (POINT CLÉ ESSENTIEL)

> **C'est le cœur fonctionnel de Psold. Ne pas simplifier, ne pas fusionner les rôles.**
> Les deux types de comptes ont des droits, des interfaces et des flux radicalement différents.
> Chaque décision d'architecture doit respecter cette séparation stricte.

---

### Compte Marchand — `role: 'merchant'`

**Qui ?** Supermarchés, grossistes, boutiques, vendeurs de produits physiques.

**Ce qu'il peut faire (et lui seul) :**
- Uploader des photos et vidéos de produits en solde ou proches de leur date de péremption
- Remplir le formulaire produit (titre, catégorie, prix original, prix promo, quantité, date péremption)
- Voir la validation IA de ses produits (accepté / refusé + raison)
- Accéder au dashboard de ses statistiques (vues, likes, commentaires par produit)
- Gérer la liste de ses produits publiés (actifs, expirés, en attente, refusés)

**Ce qu'il NE peut PAS faire :**
- Voir le bouton "Discuter" sur les produits (il est le vendeur, pas l'acheteur)
- Contacter d'autres marchands via WhatsApp depuis l'app

**Données obligatoires à l'inscription :**
- Nom complet / Nom de la boutique
- Numéro WhatsApp (**obligatoire**, validé format E.164 : `+[indicatif][numéro]`)
- Ville / Pays/ Localisation GPS
- Email ou téléphone pour l'auth Supabase

**Navigation bottom bar (marchand) :**
```
[ Accueil/Feed ]  [ Publier ]  [ Mes produits ]  [ Notifications ]  [ Settings ]
Nb: Dans les settings, le marchand peut personnaliser l'appliaction à son aise, par exemple choisir le thème qui le convient, la langue qui le convient, ajouter/modifier/supprimer une photo profil (image/Logo de l'entité ou supermarket), changer le language visuel (EN, FR, AR pour la visibilité des textes) qui lui convient. Les Navigations bottom doivent uniquement contenir des icones convenables à chaque layer (par exemple: Accueil--> uniquement icone Home, pareil pour les autres).
```

---

### Compte Client — `role: 'client'`

**Qui ?** Acheteurs, consommateurs cherchant des bonnes affaires.

**Ce qu'il peut faire :**
- Parcourir le feed géolocalisé de tous les produits validés
- Filtrer par catégorie, distance, date de péremption
- **Liker** une publication produit (toggle, optimistic update)
- **Commenter** une publication produit
- **Contacter le marchand directement sur WhatsApp** via le bouton **"Discuter"**

**Ce qu'il NE peut PAS faire :**
- Uploader des produits (le bouton "Publier" n'apparaît pas dans son interface)
- Accéder au dashboard marchand

**Données à l'inscription :**
- Prénom / Pseudo
- Email ou téléphone pour l'auth Supabase
- (WhatsApp optionnel pour le client)

**Navigation bottom bar (client) :**
```
[ Accueil/Feed ]  [ Favoris ]  [ Notifications ]  [ Settings ]
Nb: Dans les settings, le client peut personnaliser l'appliaction à son aise, par exemple choisir le thème qui le convient, la langue qui le convient, ajouter/modifier/supprimer une photo profil (avatar/images), changer le language visuel (EN, FR, AR pour la visibilité des textes) qui lui convient. Les Navigations bottom doivent uniquement contenir des icones convenables à chaque layer (par exemple: Accueil--> uniquement icone Home, pareil pour les autres).
```
**Scafolf up bar (client) :**
```
[Photo profil]                           [Search icon]

NB: Quand l'utilisateur clique sur l'icone de recherche, automatiquement la barre de recherche s'ouvre, et l'utilisateur a la possibilité de recheché le nom d'un produit mis en solde, par exemple : Vin en solde - Bangui, Désodorissant pour homme - Bangui, etc. En gros tu vas insérer les formats de recherche type SEO pour que l'utilisateur puisse avoir facilement accès à la liste de chaque produit mis en solde.

---

### Écran de Choix du Compte — UI Obligatoire

L'écran d'inscription doit présenter **deux cartes visuelles distinctes** (pas une simple liste ou un dropdown) permettant de choisir le type de compte. C'est la première impression — elle doit être claire et magnifique.

```dart
// lib/features/auth/presentation/register_choice_screen.dart
Scaffold(
  backgroundColor: const Color(0xFFFDF5E6),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(PsoldSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: PsoldSpacing.xl),
          Text('Créer un compte', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: PsoldSpacing.sm),
          Text('Choisissez votre profil', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: PsoldSpacing.xxl),

          // Carte Marchand
          _RoleCard(
            icon: Icons.storefront_rounded,
            title: 'Compte Marchand',
            subtitle: 'Je vends des produits\nen solde ou proches de la date de péremption',
            features: const [
              'Upload de photos & vidéos produits',
              'Validation IA automatique',
              'Dashboard de statistiques',
              'Visibilité auprès des acheteurs',
            ],
            color: const Color(0xFFFF6B2B),
            onTap: () => context.go('/register/merchant'),
          ),

          const SizedBox(height: PsoldSpacing.md),

          // Carte Client
          _RoleCard(
            icon: Icons.shopping_bag_rounded,
            title: 'Compte Client',
            subtitle: 'Je cherche des bonnes affaires\nsur des produits en solde',
            features: const [
              'Parcourir les produits proches de moi',
              'Liker et commenter les publications',
              'Contacter le vendeur via WhatsApp',
              'Notifications de nouvelles offres',
            ],
            color: const Color(0xFF1A1A1A),
            onTap: () => context.go('/register/client'),
          ),

          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Déjà un compte ? ', style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text('Se connecter', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFFF6B2B),
                  fontWeight: FontWeight.w600,
                )),
              ),
            ],
          ),
          const SizedBox(height: PsoldSpacing.lg),
        ],
      ),
    ),
  ),
)
```

---

### Widget `_RoleCard` — Design Premium

```dart
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> features;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon, required this.title, required this.subtitle,
    required this.features, required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(PsoldSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PsoldSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: PsoldSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
              ],
            ),
            const SizedBox(height: PsoldSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: PsoldSpacing.sm),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text(f, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
```

---

### Bouton "Discuter" — WhatsApp Direct (Clients uniquement)

> Ce bouton est **visible uniquement pour les utilisateurs avec `role: 'client'`**. # Une seule condition : Le client doit aussi avoir un compte Whatsapp
> Il ouvre directement la conversation WhatsApp avec le numéro du marchand.
> Le message est pré-rempli avec le nom du produit pour faciliter la prise de contact.

```dart
// Afficher uniquement si role == 'client'
if (currentUser.role == 'client')
  ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF25D366),   // vert WhatsApp officiel
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
    icon: const Icon(Icons.chat_rounded, size: 22),
    label: const Text('Discuter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    onPressed: () {
      final phoneNumber = product.merchantWhatsapp.replaceAll('+', '').replaceAll(' ', '');
      final message = Uri.encodeComponent(
        'Bonjour, je suis intéressé par votre produit "${product.title}" publié sur Psold. Est-il encore disponible ?'
      );
      final url = Uri.parse('https://wa.me/$phoneNumber?text=$message');
      launchUrl(url, mode: LaunchMode.externalApplication);
    },
  ),
```

---

### GoRouter — Guards basés sur le rôle

```dart
// lib/core/router.dart
redirect: (context, state) {
  final user = ref.read(currentUserProvider);

  // Non connecté → login
  if (user == null) return '/login';

  // Connecté mais pas de profil → onboarding
  if (user.profile == null) return '/onboarding';

  // Marchand essaie d'accéder à une route client-only → rediriger
  if (state.fullPath == '/upload' && user.profile!.role != 'merchant') return '/feed';

  // Client essaie d'accéder au dashboard marchand → rediriger
  if (state.fullPath?.startsWith('/merchant') == true && user.profile!.role != 'merchant') return '/feed';

  return null;  // OK, laisser passer
},
```

---

### Séparation des routes par rôle

```
/login                     → tous
/register                  → tous (choix du type de compte)
/register/merchant         → formulaire inscription marchand
/register/client           → formulaire inscription client
/onboarding                → complément de profil (selon rôle)
/feed                      → tous (contenu filtré selon rôle)
/product/:id               → tous (bouton "Discuter" visible clients seulement)
/upload                    → marchands uniquement (guard)
/merchant/dashboard        → marchands uniquement (guard)
/merchant/products         → marchands uniquement (guard)
/notifications             → tous
/settings                  → tous
/profile                   → tous
```

---

### PHASE 1 — Setup, Auth, Navigation (3-5 jours)

**Objectif** : App qui lance en < 1s, auth fonctionnel avec les 2 types de comptes, navigation adaptée au rôle.

**Tâches** :
1. Initialiser projet Flutter avec Impeller activé Android + iOS
2. Configurer Supabase (URL + anon key via `--dart-define` ou `.env`)
3. Implémenter `GoRouter` avec guards auth + guards rôle (voir section Authentification ci-dessus)
4. Écran `/register` : deux cartes visuelles **Compte Marchand** / **Compte Client** (voir `_RoleCard`)
5. Écran `/register/merchant` : nom boutique, email/tel, WhatsApp (obligatoire E.164), ville, GPS
6. Écran `/register/client` : prénom/pseudo, email/tel
7. Écran `/login` : email + OTP phone (Supabase Auth)
8. Navigation bottom bar **adaptée au rôle** :
   - Marchand : Feed | Publier | Mes produits | Notifications | Profil
   - Client : Feed | Favoris | Notifications | Profil
9. Écran onboarding animé (Lottie 2s) avec sélecteur de langue avant inscription

**Critères d'acceptation** :
- [ ] App cold start < 1s sur device mid-range Android (Snapdragon 665)
- [ ] Écran de choix de compte avec 2 cartes visuelles distinctes et magnifiques
- [ ] Login email + OTP phone fonctionnels
- [ ] Un marchand ne peut pas accéder à `/upload` s'il est client, et vice versa
- [ ] Le bouton "Discuter" (WhatsApp) apparaît **uniquement** pour les clients
- [ ] Un marchand inscrit voit automatiquement le bouton "Publier" dans la nav bar
- [ ] GoRouter guards bloquent tout accès non autorisé par rôle

---

### PHASE 2 — Upload & Validation IA (5-7 jours)

**Objectif** : Flux upload complet avec OCR + validation IA en < 2s.

**Tâches** :
1. Écran caméra avec `image_picker` + compression automatique (quality: 80, maxWidth: 1200)
2. Intégrer ML Kit Text Recognition sur chaque image sélectionnée
3. Parser les dates extraites → objet `ExpiryDate` avec confidence score
4. Formulaire auto-rempli (éditable) : titre, catégorie, prix original, prix promo, quantité, date péremption
5. Bouton "Valider" → appel Edge Function Gemini → affichage résultat
6. Si validé → upload images Supabase Storage → insert `products` table → redirection feed
7. Si rejeté → afficher raison + permettre correction

**Patterns Flutter obligatoires** :
```dart
// Tous les widgets statiques = const
const ProductCard({super.key, required this.product});

// Lazy loading listes
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) => ProductCard(product: products[index]),
)

// RepaintBoundary sur widgets complexes
RepaintBoundary(child: ProductVideoPlayer(url: product.videoUrl))
```

**Critères d'acceptation** :
- [ ] Upload (photo → OCR → formulaire → validation → publication) < 5s total
- [ ] OCR extrait correctement 95% des dates testées (formats variés)
- [ ] Produit apparaît dans le feed en temps réel après publication

---

### PHASE 3 — Feed & Interactions (5-7 jours)

**Objectif** : Feed fluide 60 FPS, real-time, interactions WhatsApp.

**Tâches** :
1. Feed principal avec `StreamProvider` Supabase Realtime sur `products` (validés uniquement)
2. Filtres : catégorie (chips), distance (slider km), tri (date péremption / popularité)
3. Géoloc avec `geolocator` → filtre produits par rayon configurable
4. Carte produit : image/vidéo thumbnail, titre, prix barré → prix promo, ville, countdown péremption, likes count
5. Écran détail produit : galerie images, vidéo player, infos complètes, section commentaires
6. Like : optimistic update (toggle immédiat UI) + sync Supabase
7. Commentaires : liste paginée (20/page) + ajout temps réel
8. Bouton "Contacter" → `url_launcher` → `wa.me/{whatsapp}?text=...` (message pré-rempli avec titre produit)
9. Infinite scroll avec pagination cursor-based (keyset pagination sur `created_at`)

**Critères d'acceptation** :
- [ ] Scroll 60 FPS constant sur liste de 50+ produits
- [ ] Like toggle < 200ms (optimistic)
- [ ] Real-time : nouveau produit apparaît dans feed sans refresh manuel
- [ ] Lien WhatsApp ouvre l'app WhatsApp directement

---

### PHASE 4 — Dashboard Marchand, Offline, Notifications (5 jours)

**Objectif** : Outils marchands, résilience réseau, engagement.

**Tâches** :
1. Dashboard marchand : stats (vues totales, likes, commentaires, produits actifs/expirés)
2. Liste "Mes produits" avec statut (en attente validation / actif / expiré / rejeté)
3. Offline mode : `flutter_cache_manager` pour images, `hive` pour cache feed (dernière page)
4. Push notifications FCM : nouveau like, nouveau commentaire, produit bientôt expiré (J-7)
5. Géoloc background : mise à jour position marchand pour pertinence du feed

**Critères d'acceptation** :
- [ ] Dashboard charge < 1s
- [ ] Feed visible en mode avion (données mises en cache)
- [ ] Notification push reçue < 5s après événement déclencheur

---

### PHASE 5 — Déploiement (2 jours)

1. Build release iOS + Android via Codemagic (signing automatique)
2. Monitoring : Sentry (crashes) + Supabase Dashboard (DB performance)
3. Tests de charge : 100 utilisateurs simultanés sur le feed

---

## RÈGLES DE CODE FLUTTER — NON NÉGOCIABLES

```dart
// 1. Const everywhere
const SizedBox(height: 16);
const Text('Psold', style: TextStyle(fontSize: 24));

// 2. Provider Riverpod — toujours @riverpod annotations
@riverpod
Future<List<Product>> feedProducts(FeedProductsRef ref, {String? category, double? radiusKm}) async {
  final supabase = ref.watch(supabaseClientProvider);
  // ...
}

// 3. Gestion d'erreurs — jamais de silent failure
ref.listen(feedProductsProvider(), (previous, next) {
  next.whenOrNull(
    error: (error, stack) => showErrorSnackBar(context, error.toString()),
  );
});

// 4. Images — toujours CachedNetworkImage
CachedNetworkImage(
  imageUrl: product.images.first,
  placeholder: (context, url) => const Skeleton(),
  errorWidget: (context, url, error) => const PlaceholderImage(),
)

// 5. Navigation — GoRouter uniquement, jamais Navigator.push direct
context.go('/product/${product.id}');
```

---

## EDGE FUNCTION GEMINI — TEMPLATE DE BASE

```typescript
// supabase/functions/validate-product/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const { category, expiry_date, images_urls, title, today } = await req.json();

  const expiryDate = new Date(expiry_date);
  const todayDate = new Date(today);
  const daysRemaining = Math.floor((expiryDate.getTime() - todayDate.getTime()) / 86400000);

  const limits: Record<string, number> = {
    alimentaire: 90,
    cosmetique: 120,
    electronique: 9999,
    autre: 90,
  };

  const maxDays = limits[category] ?? 90;

  if (daysRemaining < 1) {
    return Response.json({ validated: false, ai_score: 0, rejection_reason: "Produit déjà périmé" });
  }
  if (daysRemaining > maxDays) {
    return Response.json({
      validated: false,
      ai_score: 0,
      rejection_reason: `Péremption trop lointaine pour la catégorie "${category}" (max ${maxDays} jours)`,
    });
  }

  // Appel Gemini pour analyse qualité images + extraction infos
  const geminiResponse = await fetch("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent", {
    method: "POST",
    headers: { "Content-Type": "application/json", "x-goog-api-key": Deno.env.get("GEMINI_API_KEY")! },
    body: JSON.stringify({
      contents: [{
        parts: [
          { text: `Analyse ce produit "${title}" (catégorie: ${category}). Les images sont-elles de bonne qualité ? Le produit semble-t-il légitime ? Réponds JSON: { "quality_ok": bool, "confidence": float, "notes": string }` },
          ...images_urls.map((url: string) => ({ inline_data: { mime_type: "image/jpeg", data: url } }))
        ]
      }]
    })
  });

  const geminiData = await geminiResponse.json();
  // Extraire et parser la réponse Gemini...

  return Response.json({
    validated: true,
    ai_score: 0.9,
    rejection_reason: null,
    extracted_info: {},
  });
});
```

---

## ORDRE D'IMPLÉMENTATION — SUIVRE CETTE SÉQUENCE

```
1.  flutter create psold --platforms=ios,android
2.  Configurer pubspec.yaml (toutes les dépendances + flutter: generate: true)
3.  Copier assets/images/psold_logo.png + assets/animations/psold_logo_animation.json dans le projet
4.  Générer splash screen : dart run flutter_native_splash:create
5.  Générer launcher icon : dart run flutter_launcher_icons
6.  Créer fichiers ARB (app_fr.arb, app_en.arb, app_ar.arb) → lancer flutter gen-l10n
7.  Créer migrations SQL Supabase + activer RLS
8.  Implémenter core/ (client Supabase, router, theme, locale_provider)
9.  Feature auth/ (login → onboarding animé [Lottie 2s] → sélecteur de langue → redirection)
10. Feature upload/ (caméra → OCR → formulaire → Edge Function → publication)
11. Feature feed/ (stream Supabase → liste → filtres → géoloc)
12. Feature product/ (détail → like → commentaires → WhatsApp)
13. Feature merchant/ (dashboard → mes produits)
14. Feature settings/ (sélecteur langue + thème)
15. Notifications FCM + offline cache
16. Tests RTL (arabe) + tests de performance + optimisations finales
```

---

## DÉPENDANCES pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Backend
  supabase_flutter: ^2.0.0
  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  # Launcher Icons
  flutter_launcher_icons: ^0.14.0
  # Splash screen
  flutter_native_splash: ^2.2.11
  # UI/UX Design
  flutter_animate: ^4.5.0
  # Navigation
  go_router: ^14.0.0
  # IA / ML
  google_mlkit_text_recognition: ^0.13.0
  # Images
  image_picker: ^1.0.0
  cached_network_image: ^3.3.0
  flutter_cache_manager: ^3.3.0
  # Géoloc
  geolocator: ^11.0.0
  # Vidéo
  video_player: ^2.8.0
  # Notifications
  firebase_core: ^2.27.0
  firebase_messaging: ^14.7.0
  # WhatsApp
  url_launcher: ^6.2.0
  # Cache offline
  hive_flutter: ^1.1.0
  # Modèles
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  # Internationalisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  # Animations Lottie
  lottie: ^3.0.0
  # Splash & Launcher icon (aussi en dev)
  flutter_native_splash: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  flutter_lints: ^3.0.0
  flutter_launcher_icons: ^0.13.0
```

---

## ANIMATION LOTTIE — FICHIER `assets/animations/psold_logo_animation.json`

> Copier exactement ce JSON dans le fichier `assets/animations/psold_logo_animation.json`.
> Ne pas modifier les valeurs de couleur ni les keyframes — elles sont calibrées pour 2s exactement.

```json
{
  "v": "5.9.0",
  "fr": 30,
  "ip": 0,
  "op": 60,
  "w": 400,
  "h": 400,
  "nm": "Psold Logo Animation",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ty": 4,
      "nm": "Logo",
      "sr": 1,
      "ks": {
        "o": {
          "a": 1,
          "k": [
            {"t": 0,  "s": [0],   "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.42], "y": [0]}},
            {"t": 12, "s": [100]}
          ]
        },
        "r": {"a": 0, "k": -10},
        "p": {"a": 0, "k": [200, 210]},
        "a": {"a": 0, "k": [0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0,  "s": [0, 0],      "i": {"x": [0.5], "y": [1.4]}, "o": {"x": [0.42], "y": [0]}},
            {"t": 22, "s": [112, 112],  "i": {"x": [0.5], "y": [1]},   "o": {"x": [0.5],  "y": [0]}},
            {"t": 34, "s": [93, 93],    "i": {"x": [0.5], "y": [1]},   "o": {"x": [0.5],  "y": [0]}},
            {"t": 44, "s": [103, 103],  "i": {"x": [0.5], "y": [1]},   "o": {"x": [0.5],  "y": [0]}},
            {"t": 52, "s": [98, 98],    "i": {"x": [0.5], "y": [1]},   "o": {"x": [0.5],  "y": [0]}},
            {"t": 58, "s": [100, 100]}
          ]
        }
      },
      "ao": 0,
      "shapes": [
        {
          "ty": "gr",
          "nm": "Price Tag",
          "it": [
            {"ty": "rc", "nm": "Body", "d": 1,
              "p": {"a": 0, "k": [0, -10]},
              "s": {"a": 0, "k": [160, 195]},
              "r": {"a": 0, "k": 18}
            },
            {
              "ty": "sh", "nm": "Tip",
              "ks": {"a": 0, "k": {
                "i": [[0,0],[0,0],[0,0]],
                "o": [[0,0],[0,0],[0,0]],
                "v": [[-38,83],[38,83],[0,120]],
                "c": true
              }}
            },
            {"ty": "mm", "nm": "Merge", "mm": 1},
            {"ty": "fl", "nm": "Orange",
              "c": {"a": 0, "k": [1.0, 0.42, 0.17, 1]},
              "o": {"a": 0, "k": 100}, "r": 1
            },
            {"ty": "tr",
              "p": {"a": 0, "k": [0, 0]}, "a": {"a": 0, "k": [0, 0]},
              "s": {"a": 0, "k": [100, 100]}, "r": {"a": 0, "k": 0}, "o": {"a": 0, "k": 100}
            }
          ]
        },
        {
          "ty": "gr", "nm": "Hole",
          "it": [
            {"ty": "el", "nm": "Circle", "d": 1,
              "p": {"a": 0, "k": [0, -92]},
              "s": {"a": 0, "k": [26, 26]}
            },
            {"ty": "fl", "nm": "Cream",
              "c": {"a": 0, "k": [0.992, 0.961, 0.902, 1]},
              "o": {"a": 0, "k": 100}, "r": 1
            },
            {"ty": "tr",
              "p": {"a": 0, "k": [0, 0]}, "a": {"a": 0, "k": [0, 0]},
              "s": {"a": 0, "k": [100, 100]}, "r": {"a": 0, "k": 0}, "o": {"a": 0, "k": 100}
            }
          ]
        },
        {
          "ty": "gr", "nm": "Letter P",
          "it": [
            {
              "ty": "sh", "nm": "P Path",
              "ks": {"a": 0, "k": {
                "i": [[0,0],[0,0],[0,0],[0,-18],[20,0],[0,0],[0,0]],
                "o": [[0,0],[0,0],[18,0],[0,15],[0,0],[0,0],[0,0]],
                "v": [[-22,38],[-22,-38],[-2,-38],[28,-15],[-2,8],[-7,8],[-7,38]],
                "c": true
              }}
            },
            {"ty": "fl", "nm": "White",
              "c": {"a": 0, "k": [1, 1, 1, 1]},
              "o": {"a": 0, "k": 100}, "r": 1
            },
            {"ty": "tr",
              "p": {"a": 0, "k": [0, -5]}, "a": {"a": 0, "k": [0, 0]},
              "s": {"a": 0, "k": [100, 100]}, "r": {"a": 0, "k": 0}, "o": {"a": 0, "k": 100}
            }
          ]
        }
      ],
      "ip": 0, "op": 60, "st": 0, "bm": 0
    }
  ]
}
```

**Détail de l'animation (30 FPS, 60 frames = 2s) :**
| Frames | Effet |
|---|---|
| 0 → 12 | Fade-in opacity 0 → 100% |
| 0 → 22 | Scale 0% → 112% (spring overshoot) |
| 22 → 34 | Scale 112% → 93% (rebond 1) |
| 34 → 44 | Scale 93% → 103% (rebond 2) |
| 44 → 58 | Scale 103% → 100% (settle final) |
| Rotation | −10° fixe (étiquette inclinée naturellement) |

---

## INTERNATIONALISATION (i18n) — FR / EN / AR

### Langues supportées

| Code | Langue | Sens lecture | Statut |
|---|---|---|---|
| `fr` | Français | LTR | Langue par défaut |
| `en` | Anglais | LTR | Supporté |
| `ar` | Arabe | **RTL** | Supporté (miroir UI complet) |

---

### Configuration `pubspec.yaml` (déjà incluse ci-dessus)

Ajouter aussi dans `pubspec.yaml` la section `flutter` :

```yaml
flutter:
  generate: true   # active la génération automatique des fichiers .dart depuis les ARB
```

---

### Structure des fichiers ARB

```
lib/
└── l10n/
    ├── app_fr.arb    # Français (référence)
    ├── app_en.arb    # Anglais
    └── app_ar.arb    # Arabe
```

**`lib/l10n/app_fr.arb`** (référence — toutes les clés doivent exister ici) :

```json
{
  "@@locale": "fr",
  "appName": "Psold",
  "tagline": "Les Produits en Solde",
  "loginTitle": "Connexion",
  "loginEmail": "Adresse e-mail",
  "loginPhone": "Numéro de téléphone",
  "loginButton": "Se connecter",
  "registerTitle": "Créer un compte",
  "roleClient": "Client",
  "roleMerchant": "Marchand",
  "onboardingWhatsapp": "Numéro WhatsApp",
  "onboardingCity": "Ville",
  "feedTitle": "Produits en solde",
  "filterCategory": "Catégorie",
  "filterDistance": "Distance",
  "categoryFood": "Alimentaire",
  "categoryElectro": "Électronique",
  "categoryCosmetique": "Cosmétique",
  "categoryOther": "Autre",
  "contact": "Contacter",
  "like": "J'aime",
  "comment": "Commenter",
  "uploadTitle": "Publier un produit",
  "uploadExpiryDate": "Date de péremption",
  "uploadPrice": "Prix en solde",
  "uploadOriginalPrice": "Prix original",
  "uploadQuantity": "Quantité",
  "uploadValidate": "Valider et publier",
  "validationPending": "Validation en cours…",
  "validationSuccess": "Produit publié avec succès",
  "validationFailed": "Publication refusée : {reason}",
  "@validationFailed": { "placeholders": { "reason": { "type": "String" } } },
  "daysLeft": "{days} jours restants",
  "@daysLeft": { "placeholders": { "days": { "type": "int" } } },
  "settingsLanguage": "Langue",
  "settingsTheme": "Thème",
  "settingsThemeLight": "Clair",
  "settingsThemeDark": "Sombre",
  "settingsThemeSystem": "Système",
  "errorGeneric": "Une erreur est survenue",
  "retry": "Réessayer",
  "logout": "Se déconnecter"
}
```

**`lib/l10n/app_en.arb`** :

```json
{
  "@@locale": "en",
  "appName": "Psold",
  "tagline": "Products on Sale",
  "loginTitle": "Sign In",
  "loginEmail": "Email address",
  "loginPhone": "Phone number",
  "loginButton": "Sign in",
  "registerTitle": "Create account",
  "roleClient": "Customer",
  "roleMerchant": "Merchant",
  "onboardingWhatsapp": "WhatsApp number",
  "onboardingCity": "City",
  "feedTitle": "Products on Sale",
  "filterCategory": "Category",
  "filterDistance": "Distance",
  "categoryFood": "Food",
  "categoryElectro": "Electronics",
  "categoryCosmetique": "Cosmetics",
  "categoryOther": "Other",
  "contact": "Contact",
  "like": "Like",
  "comment": "Comment",
  "uploadTitle": "Post a product",
  "uploadExpiryDate": "Expiry date",
  "uploadPrice": "Sale price",
  "uploadOriginalPrice": "Original price",
  "uploadQuantity": "Quantity",
  "uploadValidate": "Validate & publish",
  "validationPending": "Validating…",
  "validationSuccess": "Product published successfully",
  "validationFailed": "Publication refused: {reason}",
  "@validationFailed": { "placeholders": { "reason": { "type": "String" } } },
  "daysLeft": "{days} days left",
  "@daysLeft": { "placeholders": { "days": { "type": "int" } } },
  "settingsLanguage": "Language",
  "settingsTheme": "Theme",
  "settingsThemeLight": "Light",
  "settingsThemeDark": "Dark",
  "settingsThemeSystem": "System",
  "errorGeneric": "An error occurred",
  "retry": "Try again",
  "logout": "Sign out"
}
```

**`lib/l10n/app_ar.arb`** :

```json
{
  "@@locale": "ar",
  "appName": "Psold",
  "tagline": "المنتجات المخفضة",
  "loginTitle": "تسجيل الدخول",
  "loginEmail": "البريد الإلكتروني",
  "loginPhone": "رقم الهاتف",
  "loginButton": "دخول",
  "registerTitle": "إنشاء حساب",
  "roleClient": "عميل",
  "roleMerchant": "تاجر",
  "onboardingWhatsapp": "رقم واتساب",
  "onboardingCity": "المدينة",
  "feedTitle": "المنتجات المخفضة",
  "filterCategory": "الفئة",
  "filterDistance": "المسافة",
  "categoryFood": "غذائي",
  "categoryElectro": "إلكترونيات",
  "categoryCosmetique": "مستحضرات تجميل",
  "categoryOther": "أخرى",
  "contact": "تواصل",
  "like": "إعجاب",
  "comment": "تعليق",
  "uploadTitle": "نشر منتج",
  "uploadExpiryDate": "تاريخ انتهاء الصلاحية",
  "uploadPrice": "سعر التخفيض",
  "uploadOriginalPrice": "السعر الأصلي",
  "uploadQuantity": "الكمية",
  "uploadValidate": "تحقق ونشر",
  "validationPending": "جارٍ التحقق…",
  "validationSuccess": "تم نشر المنتج بنجاح",
  "validationFailed": "رُفض النشر: {reason}",
  "@validationFailed": { "placeholders": { "reason": { "type": "String" } } },
  "daysLeft": "{days} أيام متبقية",
  "@daysLeft": { "placeholders": { "days": { "type": "int" } } },
  "settingsLanguage": "اللغة",
  "settingsTheme": "المظهر",
  "settingsThemeLight": "فاتح",
  "settingsThemeDark": "داكن",
  "settingsThemeSystem": "النظام",
  "errorGeneric": "حدث خطأ",
  "retry": "أعد المحاولة",
  "logout": "تسجيل الخروج"
}
```

---

### Configuration `lib/l10n/l10n.dart`

```dart
import 'package:flutter/material.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('ar'),
  ];

  static const Locale defaultLocale = Locale('fr');

  static String languageName(String code) {
    switch (code) {
      case 'fr': return 'Français';
      case 'en': return 'English';
      case 'ar': return 'العربية';
      default: return code;
    }
  }
}
```

---

### Provider de locale — `lib/core/locale_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _localeBoxKey = 'settings';
const _localeKey = 'locale';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final box = Hive.box(_localeBoxKey);
  final saved = box.get(_localeKey, defaultValue: 'fr') as String;
  return LocaleNotifier(Locale(saved));
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(super.initialLocale);

  Future<void> setLocale(String languageCode) async {
    final box = Hive.box(_localeBoxKey);
    await box.put(_localeKey, languageCode);
    state = Locale(languageCode);
  }
}
```

---

### Intégration dans `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(const ProviderScope(child: PsoldApp()));
}

class PsoldApp extends ConsumerWidget {
  const PsoldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Psold',
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: psoldLightTheme,
      darkTheme: psoldDarkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
```

---

### Support RTL — Arabe

Flutter gère automatiquement le **miroir de l'interface** (RTL) quand la locale est `ar`.
Points d'attention obligatoires :

```dart
// 1. Utiliser EdgeInsetsDirectional au lieu de EdgeInsets
//    WRONG:
Padding(padding: EdgeInsets.only(left: 16))
//    CORRECT:
Padding(padding: EdgeInsetsDirectional.only(start: 16))

// 2. Utiliser TextAlign.start au lieu de TextAlign.left
Text('Psold', textAlign: TextAlign.start)

// 3. Icônes directionnelles : utiliser Icons.arrow_forward (miroir auto)
//    au lieu de Icons.arrow_back / arrow_forward fixés manuellement

// 4. Pour vérifier le sens courant en runtime :
final isRTL = Directionality.of(context) == TextDirection.rtl;
```

---

### Sélecteur de langue — `lib/features/settings/language_selector.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectorSheet extends ConsumerWidget {
  const LanguageSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l.settingsLanguage, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        for (final lang in ['fr', 'en', 'ar'])
          ListTile(
            leading: Text(_flag(lang), style: const TextStyle(fontSize: 24)),
            title: Text(L10n.languageName(lang)),
            trailing: currentLocale.languageCode == lang
                ? const Icon(Icons.check_circle, color: Color(0xFFFF6B2B))
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).setLocale(lang);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  String _flag(String code) {
    switch (code) {
      case 'fr': return '🇫🇷';
      case 'en': return '🇬🇧';
      case 'ar': return '🇸🇦';
      default: return '🌐'; # Tu dois obligatoirement utiliser une icone réelle                               #  (type lucide react).
    }
  }
}
```

> Afficher ce sélecteur via un `showModalBottomSheet` depuis l'écran Paramètres ou depuis l'onboarding.

---

### Commande de génération (à lancer après chaque modification des ARB)

```bash
flutter gen-l10n
```

Cela génère `lib/flutter_gen/gen_l10n/app_localizations.dart` et les sous-classes par langue.

---

### Mise à jour de la structure du projet (i18n)

```
lib/
├── l10n/
│   ├── l10n.dart           # Liste des locales + noms
│   ├── app_fr.arb          # Référence français
│   ├── app_en.arb          # Anglais
│   └── app_ar.arb          # Arabe (RTL)
├── core/
│   └── locale_provider.dart  # Provider Riverpod + persistance Hive
└── features/
    └── settings/
        └── language_selector.dart  # BottomSheet sélecteur de langue
```

---

## UX & DESIGN EXCELLENCE — RÈGLES NON NÉGOCIABLES

> L'expérience utilisateur de Psold doit être **visuellement magnifique** tout en restant légère et rapide.
> Chaque écran doit donner l'impression d'une app premium, pas d'un prototype.

---

### Système d'espacement — Grille de 8px

```dart
class PsoldSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
```

**Règle** : tous les paddings, margins, gaps utilisent un multiple de 8. Jamais de valeurs arbitraires comme 7, 13, 21.

---

### Typographie — Échelle complète

```dart
// Dans psoldLightTheme / psoldDarkTheme, ajouter :
textTheme: const TextTheme(
  displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -1.5),
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w800, letterSpacing: -1.0),
  displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5),
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
  headlineMedium:TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
  titleLarge:    TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  titleMedium:   TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
  labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
),
```

Police recommandée : **Space Grotesk** (Google Fonts)
```yaml
# pubspec.yaml
google_fonts: ^6.1.0
```
```dart
import 'package:google_fonts/google_fonts.dart';
// Dans ThemeData :
textTheme: GoogleFonts.spaceGroteskTextTheme(Theme.of(context).textTheme),
```

---

### Cartes Produit — Design Premium

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,                            // surface blanche sur fond crème
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ...,
)
```

**Règles cartes :**
- Corner radius : **20px** pour les cartes principales, **12px** pour les éléments secondaires
- Shadow : toujours subtile (`opacity: 0.05–0.08`), jamais harsh
- Image ratio : **4:3** pour les produits alimentaires, **1:1** pour électronique/cosmétique
- Countdown badge (jours restants) : pastille colorée en haut-droite de l'image
  - 1–7 jours → rouge `#E53935`
  - 8–30 jours → orange `#FF6B2B`
  - 31+ jours → vert `#43A047`

---

### Boutons — Hiérarchie visuelle

```dart
// Bouton primaire (CTA principal)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFF6B2B),   // orange brand
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
  ),
  ...
)

// Bouton secondaire (outline)
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFFFF6B2B),
    minimumSize: const Size(double.infinity, 56),
    side: const BorderSide(color: Color(0xFFFF6B2B), width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  ...
)

// Bouton WhatsApp (vert spécifique)
ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF25D366),  // vert WhatsApp officiel
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  ),
  icon: const Icon(Icons.chat_rounded),
  label: Text(AppLocalizations.of(context)!.contact),
  ...
)
```

---

### Microinteractions & Animations Flutter

```dart
// 1. Like animation — scale bounce au tap
GestureDetector(
  onTap: () {
    _likeController.forward().then((_) => _likeController.reverse());
    ref.read(likeProvider(productId).notifier).toggle();
  },
  child: ScaleTransition(
    scale: Tween(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    ),
    child: Icon(
      isLiked ? Icons.favorite : Icons.favorite_border,
      color: isLiked ? Colors.red : Colors.grey,
    ),
  ),
)

// 2. Transitions de pages — fade + slide
CustomTransitionPage(
  child: screen,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: SlideTransition(
        position: Tween(begin: const Offset(0.05, 0), end: Offset.zero)
            .animate(CurveTween(curve: Curves.easeOut).animate(animation)),
        child: child,
      ),
    );
  },
)

// 3. Skeleton loading (jamais de spinner seul)
// Utiliser shimmer effect sur les cartes en chargement
AnimatedContainer(
  duration: const Duration(milliseconds: 800),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFEEEEEE), Color(0xFFF5F5F5), Color(0xFFEEEEEE)],
    ),
    borderRadius: BorderRadius.circular(20),
  ),
)
```

---

### NavigationBar — Design précis

```dart
NavigationBar(
  backgroundColor: PsoldColors.backgroundLight,      // #FDF5E6
  indicatorColor: PsoldColors.navBarActiveIndicator, // #E1E0E1
  elevation: 0,
  height: 72,
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home_outlined),    selectedIcon: Icon(Icons.home_rounded),       label: 'Accueil'),
    NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle_rounded), label: 'Publier'),
    NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications_rounded), label: 'Alertes'),
    NavigationDestination(icon: Icon(Icons.person_outline),   selectedIcon: Icon(Icons.person_rounded),     label: 'Profil'),
  ],
)
```

---

### États vides & Erreurs — Jamais une page blanche

```dart
// État vide (feed sans produits)
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/psold_logo.png', width: 80, opacity: const AlwaysStoppedAnimation(0.3)),
      const SizedBox(height: PsoldSpacing.md),
      Text('Aucun produit disponible', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: PsoldSpacing.sm),
      Text('Revenez plus tard ou élargissez votre zone de recherche',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center),
    ],
  ),
)

// Erreur réseau
Center(
  child: Column(children: [
    const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
    const SizedBox(height: PsoldSpacing.md),
    Text(AppLocalizations.of(context)!.errorGeneric),
    TextButton(onPressed: retry, child: Text(AppLocalizations.of(context)!.retry)),
  ]),
)
```

---

### Checklist Design avant livraison

- [ ] Toutes les couleurs viennent de `PsoldColors` ou `Theme.of(context).colorScheme`
- [ ] Tous les espacements sont multiples de 8
- [ ] Police Space Grotesk appliquée partout
- [ ] Cartes avec shadow subtile et radius 20px
- [ ] Boutons primary orange `#FF6B2B`, hauteur 56px min
- [ ] Badge countdown coloré sur toutes les cartes produit
- [ ] Skeleton loading sur tous les états de chargement (pas de CircularProgressIndicator seul)
- [ ] Transitions de pages avec fade + slide
- [ ] Like animation avec bounce
- [ ] RTL validé sur 3 écrans clés en arabe (feed, détail produit, onboarding)
- [ ] Mode sombre testé sur tous les écrans

---

## CONTRAINTES DE SÉCURITÉ

- **Jamais** de clé API dans le code client Flutter → utiliser `--dart-define` ou variables d'environnement Supabase Edge Functions
- RLS activé sur toutes les tables Supabase (voir migrations)
- Validation côté serveur (Edge Function) en plus de la validation côté client
- WhatsApp number format : valider E.164 (`+[code pays][numéro]`) côté client avant enregistrement
- Pas de stockage de données personnelles au-delà du strict nécessaire (conformité RGPD-like)

---

## MÉTHODE DE TRAVAIL (MMM)

Respecter cette progression par phase :

1. **Make it Work** — Fonctionnalité qui marche, même laide
2. **Make it Right** — Refactor propre, gestion erreurs, edge cases
3. **Make it Fast** — Profiler, éliminer jank, < 1s partout

Ne pas optimiser prématurément. Profiler avec `flutter devtools` avant toute optimisation.

---

## DÉBUT — PREMIÈRE INSTRUCTION

**Commence par la Phase 1** :

1. Génère `pubspec.yaml` complet
2. Crée `lib/core/supabase_client.dart` avec init singleton
3. Crée `lib/core/router.dart` avec GoRouter + 3 guards (unauthenticated / no-profile / authenticated)
4. Crée les écrans squelettes : `LoginScreen`, `OnboardingScreen`, `FeedScreen`
5. Montre-moi le plan de fichiers complet avant d'écrire du code

**Attends ma confirmation du plan avant d'implémenter.**
