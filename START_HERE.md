# PSOLD — INSTRUCTIONS D'ORCHESTRATION POUR L'AGENT

> **LIS CE FICHIER EN ENTIER AVANT DE FAIRE QUOI QUE CE SOIT.**
> Ce fichier est ton point d'entrée. Il te dit quoi lire, quel skill utiliser, et dans quel ordre travailler.

---

## ÉTAPE 0 — LECTURE OBLIGATOIRE AVANT TOUTE TÂCHE

Avant d'écrire une seule ligne de code, tu dois lire le fichier de spécifications complet :

```
SPEC.md
```

Ce fichier contient :
- Le contexte produit et les objectifs de l'app Psold
- Le stack technologique complet avec les versions exactes
- Le design system et la palette de couleurs officielle
- La structure du projet Flutter
- Le schéma de base de données PostgreSQL complet
- Les règles métier IA (validation produit)
- La spécification des deux types de comptes (Marchand / Client) — **point clé**
- Les fichiers ARB multilingues (FR / EN / AR) prêts à copier
- Le JSON Lottie de l'animation logo (à copier dans `assets/animations/`)
- Les règles UX et design non négociables
- Les critères d'acceptation par phase

**Ne commence aucune tâche sans avoir lu `SPEC.md` intégralement.**

---

## SKILLS DISPONIBLES ET LEURS RÔLES

Tu as accès à 3 skills spécialisés. Chaque skill augmente tes capacités sur un domaine précis.
Voici comment les activer et quand les utiliser :

---

### SKILL 1 — `flutter-expert`

**Activation :**
```
use flutter-expert
```

**Domaine :** Code Flutter/Dart — logique métier, state management, navigation, performances, intégrations SDK.

**Utilise ce skill pour :**
- Initialiser le projet Flutter (`flutter create psold`)
- Configurer Riverpod 2.x avec les annotations `@riverpod`
- Implémenter GoRouter avec les guards de rôle (marchand / client)
- Intégrer Supabase Flutter SDK (auth, realtime, storage)
- Coder ML Kit Text Recognition (OCR dates de péremption)
- Appeler les Edge Functions Supabase (validation Gemini)
- Implémenter le feed realtime avec `StreamProvider`
- Gérer la pagination cursor-based sur le feed
- Coder le mode offline (Hive cache + flutter_cache_manager)
- Intégrer Firebase Cloud Messaging (push notifications)
- Implémenter la persistance de la locale (Riverpod + Hive)
- Optimiser les performances (const widgets, RepaintBoundary, lazy lists)
- Générer le splash screen et le launcher icon

**Exemple d'utilisation :**
```
use flutter-expert

Tâche : Implémenter le GoRouter avec 3 guards d'authentification et les guards de rôle
marchand/client tels que définis dans SPEC.md (section "Séparation des routes par rôle").
Respecte exactement les routes listées dans la spec.
```

---

### SKILL 2 — `flutter-design`

**Activation :**
```
use flutter-design
```

**Domaine :** UI/UX Flutter — écrans, widgets personnalisés, animations, design system, theming.

**Utilise ce skill pour :**
- Créer le `ThemeData` complet (PsoldColors, PsoldSpacing, Space Grotesk)
- Construire l'écran d'onboarding avec l'animation Lottie (2s)
- Construire l'écran de choix de compte avec les deux cartes `_RoleCard`
- Designer les cartes produit (shadow, radius 20px, badge countdown coloré)
- Implémenter la NavigationBar avec les couleurs exactes de SPEC.md
- Créer le bouton "Discuter" (vert WhatsApp `#25D366`)
- Implémenter les microinteractions (like bounce, transitions fade+slide)
- Coder les skeleton loaders (états de chargement)
- Designer les états vides et les écrans d'erreur
- Implémenter le sélecteur de langue (BottomSheet avec drapeaux)
- Construire le dashboard marchand (stats visuelles)
- S'assurer que le RTL arabe est correctement appliqué sur tous les écrans

**Exemple d'utilisation :**
```
use flutter-design

Tâche : Créer l'écran de choix de compte (/register) avec les deux cartes visuelles
Marchand et Client, exactement comme défini dans SPEC.md (section "Écran de Choix du Compte").
Utilise PsoldColors, PsoldSpacing, et le widget _RoleCard documenté dans la spec.
Background : #FDF5E6.
```

---

### SKILL 3 — `fullstack-developer`

**Activation :**
```
use fullstack-developer
```

**Domaine :** Backend, base de données, infrastructure, déploiement.

**Utilise ce skill pour :**
- Écrire et exécuter les migrations SQL Supabase (schéma complet dans SPEC.md)
- Activer et configurer le Row Level Security (RLS) sur toutes les tables
- Écrire les Edge Functions Deno (validation produit avec Gemini API)
- Configurer les variables d'environnement Supabase (GEMINI_API_KEY, etc.)
- Configurer Codemagic pour les builds iOS et Android (signing automatique)
- Mettre en place le monitoring (Sentry crashes + Supabase dashboard)
- Effectuer les tests de charge (100 utilisateurs simultanés)

**Exemple d'utilisation :**
```
use fullstack-developer

Tâche : Créer toutes les migrations SQL Supabase listées dans SPEC.md
(section "SCHÉMA BASE DE DONNÉES"). Activer le RLS sur chaque table
et créer les policies exactement comme documenté dans la spec.
```

---

## ORDRE D'EXÉCUTION DES TÂCHES — SÉQUENCE IMPOSÉE

Respecte impérativement cet ordre. Ne passe pas à l'étape suivante avant que les critères
d'acceptation de l'étape en cours soient satisfaits (voir SPEC.md pour chaque critère).

```
ÉTAPE 1   [flutter-expert]      Créer le projet Flutter + configurer pubspec.yaml complet
ÉTAPE 2   [flutter-expert]      Copier les assets (logo PNG + Lottie JSON) dans assets/
ÉTAPE 3   [flutter-expert]      Générer splash screen (flutter_native_splash)
ÉTAPE 4   [flutter-expert]      Générer launcher icon (flutter_launcher_icons)
ÉTAPE 5   [flutter-expert]      Créer les fichiers ARB + lancer flutter gen-l10n
ÉTAPE 6   [fullstack-developer] Créer les migrations SQL Supabase + activer RLS
ÉTAPE 7   [flutter-expert]      Implémenter core/ (Supabase client, GoRouter, theme, locale_provider)
ÉTAPE 8   [flutter-design]      Créer le ThemeData complet (PsoldColors, PsoldSpacing, Space Grotesk)
ÉTAPE 9   [flutter-design]      Construire l'écran onboarding animé (Lottie 2s + sélecteur de langue)
ÉTAPE 10  [flutter-design]      Construire l'écran de choix de compte (2 cartes Marchand / Client)
ÉTAPE 11  [flutter-expert]      Implémenter les formulaires d'inscription (marchand + client)
ÉTAPE 12  [flutter-expert]      Implémenter l'écran de login (email + OTP phone)
ÉTAPE 13  [flutter-expert]      Implémenter les guards GoRouter par rôle
ÉTAPE 14  [flutter-expert]      Implémenter la NavigationBar adaptée au rôle (marchand vs client)
ÉTAPE 15  [fullstack-developer] Créer l'Edge Function Gemini (validation produit)
ÉTAPE 16  [flutter-expert]      Implémenter le flux Upload (caméra → OCR → formulaire → Edge Function)
ÉTAPE 17  [flutter-design]      Construire les écrans Upload (UI formulaire, feedback validation IA)
ÉTAPE 18  [flutter-expert]      Implémenter le feed realtime (StreamProvider + pagination)
ÉTAPE 19  [flutter-design]      Construire les cartes produit et l'écran de détail
ÉTAPE 20  [flutter-expert]      Implémenter likes (optimistic), commentaires, bouton "Discuter"
ÉTAPE 21  [flutter-design]      Construire le dashboard marchand (stats + liste produits)
ÉTAPE 22  [flutter-expert]      Implémenter offline cache (Hive) + push notifications (FCM)
ÉTAPE 23  [flutter-design]      Valider RTL arabe sur tous les écrans clés
ÉTAPE 24  [flutter-expert]      Profiler les performances + optimisations (< 2s partout)
ÉTAPE 25  [fullstack-developer] Build release iOS + Android via Codemagic + monitoring
```

---

## RÈGLES DE TRAVAIL GÉNÉRALES

1. **Lire SPEC.md avant chaque étape** — même si tu l'as déjà lu. Relis la section concernée.
2. **Activer le bon skill avant de commencer** une étape — ne code pas sans skill activé.
3. **Ne jamais inventer** une couleur, un espacement, une police, ou une route qui n'est pas dans SPEC.md.
4. **Respecter les critères d'acceptation** listés dans SPEC.md pour chaque phase avant de passer à la suivante.
5. **Signaler immédiatement** si une information dans SPEC.md est insuffisante ou contradictoire — ne pas improviser.
6. **Toujours utiliser** `PsoldColors`, `PsoldSpacing`, et `AppLocalizations.of(context)!` — jamais de valeurs codées en dur.
7. **Le bouton "Discuter"** ne doit apparaître que pour `role == 'client'` — vérifier ce point sur chaque écran produit.
8. **Les deux types de comptes** sont une contrainte absolue — ne jamais les fusionner, ne jamais donner à un client les droits d'un marchand.

---

## RÉSUMÉ RAPIDE — QUEL SKILL POUR QUOI ?

| Tu travailles sur... | Skill à utiliser |
|---|---|
| Architecture, logique, state management, SDK | `flutter-expert` |
| Écrans, widgets, animations, design, couleurs | `flutter-design` |
| Base de données, backend, Edge Functions, CI/CD | `fullstack-developer` |
| Tu ne sais pas lequel choisir | `flutter-expert` par défaut |

---

A la fin de la première phase (phase 1), génère un fichier nommé PROGRESS.md qui a pour objectif que tu note chacune de tes progression dans ce projet (toutes les tâches réalisées, les fonctionnalités implémentées, et le niveau du pourcentage de tes tâches réalisée pour ce projet).

---

*Référence principale : fichier `SPEC.md` — source de vérité absolue pour tout ce projet.*
