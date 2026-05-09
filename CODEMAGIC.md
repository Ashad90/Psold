# Guide d'installation et configuration Codemagic — Psold

Ce fichier décrit toutes les étapes pour activer et configurer Codemagic CI/CD pour l'application Psold. Chaque section correspond à une étape à suivre dans l'ordre.

---

## Table des matières

1. [Prérequis](#1-prérequis)
2. [Créer un compte Codemagic](#2-créer-un-compte-codemagic)
3. [Push le projet sur GitHub](#3-push-le-projet-sur-github)
4. [Créer le keystore Android](#4-créer-le-keystore-android)
5. [Encoder le keystore en base64](#5-encoder-le-keystore-en-base64)
6. [Ajouter le projet sur Codemagic](#6-ajouter-le-projet-sur-codemagic)
7. [Configurer les variables d'environnement](#7-configurer-les-variables-denvironnement)
8. [Configurer les triggers de build](#8-configurer-les-triggers-de-build)
9. [Lancer le premier build](#9-lancer-le-premier-build)
10. [Configurer le publishing sur le Play Store](#10-configurer-le-publishing-sur-le-play-store)
11. [Dépannage](#11-dépannage)

---

## 1. Prérequis

Avant de commencer, assure-toi d'avoir :

- **Windows 10/11** avec PowerShell 5.1+
- **Flutter SDK** installé (`flutter --version`)
- **Git** installé (`git --version`)
- **Compte GitHub** (ou GitLab / Bitbucket)
- **Compte Codemagic** gratuit sur [codemagic.io](https://codemagic.io)
- **Compte Google Play Console** (pour déployer sur Android)
- **Android Studio** (optionnel, pour générer le keystore)

---

## 2. Créer un compte Codemagic

1. Va sur **[codemagic.io](https://codemagic.io)**
2. Clique sur **"Get Started for free"**
3. Connecte-toi avec **GitHub** (recommandé) ou Google / email
4. Valide ton email si nécessaire
5. Tu arrives sur le dashboard Codemagic

> **Free tier** : 500 minutes de build/mois. Suffisant pour developper et tester.

---

## 3. Push le projet sur GitHub

Si ce n'est pas déjà fait, push le projet sur GitHub :

```powershell
cd C:/Users/crede/OneDrive/Desktop/Psold

# Initialise Git (si pas déjà fait)
git init

# Ajoute tous les fichiers
git add .

# Commit initial
git commit -m "Psold app - initial commit with Codemagic setup"

# Ajoute le remote (remplace par ton repo GitHub)
git remote add origin https://github.com/TON_USERNAME/psold.git

# Push sur main
git branch -M main
git push -u origin main
```

---

## 4. Créer le keystore Android

Le keystore est nécessaire pour signer les APK release avant de les publier sur le Play Store.

### Option A — Avec keytool (JDK)

```powershell
cd C:/Users/crede/OneDrive/Desktop/Psold/android/app

# Génère le keystore (réponds aux questions)
keytool -genkey -v -keystore upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

Quand il te demande le mot de passe du keystore → note-le quelque part (tu en auras besoin).

### Option B — Avec Android Studio

1. Ouvre **Android Studio**
2. Menu → **Build → Generate Signed Bundle / APK**
3. Sélectionne **Android App Bundle** ou **APK**
4. Clique **Create new** dans la section Key store
5. Remplis le formulaire :
   - **Key store path** : `C:\Users\crede\OneDrive\Desktop\Psold\android\app\upload-keystore.jks`
   - **Key store password** : note ce mot de passe
   - **Key alias** : `upload`
   - **Key password** : note ce mot de passe
   - **Validity (years)** : `100`
   - **Certificate** : remplis ton nom et ton organisation
6. Clique **OK**

---

## 5. Encoder le keystore en base64

Le keystore doit être envoyé à Codemagic via une variable d'environnement. Pour des raisons de sécurité, on l'encode en base64.

### Sur Windows (PowerShell)

```powershell
cd C:/Users/crede/OneDrive/Desktop/Psold/android/app

# Encode le keystore en base64
certutil -encode upload-keystore.jks keystore_base64.txt

# Le résultat est dans keystore_base64.txt — ouvre-le et copie tout le contenu
Get-Content keystore_base64.txt
```

Copie **tout le contenu** du fichier (il fait plusieurs lignes). Sauvegarde-le quelque part (txt temporaire).

### Vérification

```powershell
# Vérifie que le fichier existe et sa taille
Get-Item upload-keystore.jks | Select-Object Name, @{Name="SizeKB";Expression={[math]::Round($_.Length/1KB,1)}}
```

Le keystore doit faire quelques KB (ex: 2-4 KB).

---

## 6. Ajouter le projet sur Codemagic

### 6.1 — Créer l'app sur Codemagic

1. Connecte-toi sur **[app.codemagic.io](https://app.codemagic.io)**
2. Clique **"Add new app"** (bouton vert en haut à droite)
3. **Select repository provider** :
   - Si tu as choisi GitHub → clique **"Connect with GitHub"**
   - Autorise l'accès si demandé
4. **Select repository** : choisis `psold`
5. **Select branch** : `main`
6. Codemagic détecte automatiquement Flutter → clique **"Set up build"**

### 6.2 — Configurer le build (Workflow Editor)

Dans l'écran de configuration :

1. **Build for platforms** → sélectionne **Android**
2. **Instance type** → **Windows x2** (le plus rapide pour Android sur Windows)
3. **Flutter version** → **stable** (par défaut)
4. **Build mode** → **Release**
5. **Build arguments** (champ en bas) :
   ```
   --split-per-abi
   ```
   > Cela génère 3 APKs : arm64 (32MB), armeabi-v7a (26MB), x86_64 (34MB)

6. Clique **"Save"** ou **"Create"**

### 6.3 — Vérifier le fichier codemagic.yaml

Le fichier [`codemagic.yaml`](codemagic.yaml) est déjà à la racine du projet. Codemagic le détecte automatiquement et utilise ses workflows au lieu des settings UI.

Si tu préfères utiliser l'UI au lieu du YAML :
- Supprime ou renomme `codemagic.yaml`
- Recommence depuis l'étape 6.2

---

## 7. Configurer les variables d'environnement

Les variables d'environnement contiennent les secrets (URLs, clés, keystore). Elles sont chiffrées et ne sont jamais exposées dans les logs.

### 7.1 — Créer les groupes de variables

1. Dans Codemagic → **App settings** (icône engrenage à côté de ton app)
2. Menu gauche → **Environment variables**
3. Clique **"Add variable group"** → appelle-le `supabase_credentials`

### 7.2 — Ajouter les variables une par une

Pour **chaque** variable ci-dessous :

1. Clique **"Add variable"**
2. Remplis :
   - **Name** : `SUPABASE_URL`
   - **Value** : `https://TON-PROJECT.supabase.co` (remplace par ton URL Supabase réelle)
   - ✅ **Secure** : cocher si c'est une clé/secret
   - ✅ **Expand** : cocher pour que la valeur soit accessible dans les scripts
3. Clique **"Save"**

#### Groupe : `supabase_credentials`

| Name | Value | Secure |
|---|---|---|
| `SUPABASE_URL` | `https://xxxx.supabase.co` | Non |
| `SUPABASE_ANON_KEY` | `eyJ...` (ta clé anon) | Oui |

Pour trouver tes credentials Supabase :
1. Va sur [supabase.com](https://supabase.com) → ton projet
2. **Settings → API**
3. Copie **Project URL** et **anon public** (clé `supabaseAnonKey`)

#### Groupe : `keystore`

| Name | Value | Secure |
|---|---|---|
| `ANDROID_KEYSTORE` | Contenu complet du fichier `keystore_base64.txt` | Oui |
| `KEYSTORE_STORE_PASSWORD` | Mot de passe du keystore (celui que tu as défini à l'étape 4) | Oui |
| `KEYSTORE_KEY_PASSWORD` | Mot de passe de la clé (même que store password si tu as utilisé keytool) | Oui |
| `KEYSTORE_KEY_ALIAS` | `upload` | Non |

#### Groupe : `google_play_credentials` (optionnel — pour publishing automatique)

| Name | Value | Secure |
|---|---|---|
| `GOOGLE_PLAY_JSON_KEY` | Contenu JSON du fichier de compte de service Google | Oui |

Pour créer ce JSON :
1. [Google Cloud Console](https://console.cloud.google.com) → **IAM & Admin → Service Accounts**
2. Crée un compte de service
3. Télécharge le JSON (clé API)
4. Dans **Play Console → Users and permissions**, ajoute ce compte de service avec le rôle **Admin complet**

### 7.3 — Lier les groupes à l'app

1. Dans **App settings → Environment variables**
2. Chaque groupe que tu crées est automatiquement lié à l'app
3. Vérifie que tous les groupes sont listés

---

## 8. Configurer les triggers de build

Les triggers permettent de lancer automatiquement un build à chaque push ou pull request.

### 8.1 — Activer les triggers automatiques

1. Dans **App settings → Build triggers**
2. Configure :

#### Trigger sur push (branche main)

- ✅ **Trigger on push**
- **Watched branch patterns** :
  - Pattern : `main` (type : Include)

#### Trigger sur pull request

- ✅ **Trigger on pull request update**
- **Watched branch patterns** :
  - Pattern : `*` (type : Include, watching **source** branch)

#### Annuler les builds obsolètes

- ✅ **Cancel outdated webhook builds** → active cette option pour éviter de gaspiller des minutes de build

### 8.2 — Trigger par tag (release)

Pour déclencher un build release quand tu crées un tag :

- ✅ **Trigger on tag creation**
- **Tag pattern** : `v*` (tous les tags commençant par `v`)

---

## 9. Lancer le premier build

### 9.1 — Build manuel

1. Depuis le dashboard Codemagic, clique sur ton app **Psold**
2. Clique le bouton **"Start build"** (ou **"Start first build"** si c'est le premier)
3. Sélectionne le workflow : **`android-release`**
4. Clique **"Start"**

### 9.2 — Suivre le build

L'écran de build montre les logs en temps réel :

```
✓ Get Flutter packages    (flutter pub get)
✓ Run flutter analyze       (flutter analyze)
✓ Run tests                 (flutter test)
✓ Build release APK arm64  (flutter build apk --release --target-platform android-arm64)
✓ Build release APK arm32   (flutter build apk --release --target-platform android-armeabi-v7a)
✓ Build App Bundle          (flutter build appbundle --release)
✓ Publishing...           (envoi vers Play Store si configuré)
```

Durée estimée : **8-12 minutes** (premier build), puis **4-6 minutes** (builds suivants, grâce au cache).

### 9.3 — Télécharger les APKs

Quand le build est terminé :

1. Clique sur le build dans la liste (à gauche)
2. Va dans l'onglet **Artifacts**
3. Télécharge :
   - `app-arm64-v8a-release.apk` (~33 MB) — pour appareils récents
   - `app-armeabi-v7a-release.apk` (~27 MB) — pour appareils anciens (marché africain)
   - `app.aab` (~30 MB) — pour le Play Store

### 9.4 — Installer sur un téléphone pour tester

```powershell
# Installe sur téléphone branché en USB (ADB doit être installé)
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Ou installe via WiFi (téléphone et PC sur le même réseau)
adb connect 192.168.1.xx:5555
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## 10. Configurer le publishing sur le Play Store

Une fois le build OK, tu peux configurer la publication automatique.

### 10.1 — Publier automatiquement après chaque build

1. **App settings → Publishing**
2. Ajoute une intégration **Google Play** :
   - Clique **"Connect to Google Play"**
   - Autorise l'accès à ton compte Play Console
3. Configure :
   - **Track** : `production` (ou `beta` / `alpha` pour tester)
   - **Release status** : `completed` (publication immédiate)

### 10.2 — Publier via le workflow (recommandé)

Le fichier `codemagic.yaml` contient déjà la configuration. Assure-toi que le groupe `google_play_credentials` est bien configuré (étape 7.2).

Le workflow `android-release` publie automatiquement sur le Play Store après chaque build réussi sur la branche `main`.

### 10.3 — Publier manuellement

Si tu ne veux pas de publication automatique :

1. Télécharge le fichier `.aab` (App Bundle) depuis les Artifacts
2. Va sur [play.google.com/console](https://play.google.com/console)
3. **Production → New release**
4. Upload le `.aab`

---

## 11. Dépannage

### Build échoue avec "ANDROID_KEYSTORE not found"

**Cause** : La variable `ANDROID_KEYSTORE` n'est pas définie ou mal encodée.

**Solution** :
1. Vérifie que le contenu du fichier base64 ne contient pas de sauts de ligne inutiles
2. Assure-toi que les variables `KEYSTORE_*_PASSWORD` sont correctes
3. Teste le keystore localement :

```powershell
cd C:/Users/crede/OneDrive/Desktop/Psold/android/app
keytool -list -keystore upload-keystore.jks -v
# Entre le mot de passe pour vérifier
```

### Build échoue avec "Permission denied" sur le keystore

**Cause** : Le keystore a été créé avec un chemin absolue trop long.

**Solution** : Recrée le keystore dans un chemin simple :
```powershell
cd C:/Users/crede/OneDrive/Desktop/Psold/android/app
keytool -genkey -v -keystore upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000 -storepass TON_MOT_DE_PASSE -keypass TON_MOT_DE_PASSE
```

### Build trop long (> 30 minutes)

**Cause** : Le build est en attente (queue) ou le réseau est lent.

**Solution** :
- Le free tier a une limite de 500 min/mois — vérifie ton usage dans **Settings → Billing**
- Le cache (~10-15 min de temps de build) est activé par défaut dans `codemagic.yaml`

### "No builds found" après avoir pushé sur GitHub

**Cause** : Codemagic n'a pas accès au repo ou le webhook n'est pas configuré.

**Solution** :
1. **App settings → Build triggers**
2. Vérifie que le repo et la branche sont corrects
3. Clique **"Re-check webhook status"**
4. Si besoin, va dans GitHub → **Settings → Webhooks** et vérifie que le webhook Codemagic existe

### Variables d'environnement non accessibles dans le build

**Cause** : Les variables ne sont pas dans le bon groupe ou ne sont pas cochées "Expand".

**Solution** :
1. Dans **App settings → Environment variables**, clique sur une variable
2. Assure-toi que ✅ **Expand variable** est coché
3. Redémarre un build

### Firebase / Google Services error

**Cause** : Le fichier `google-services.json` est manquant ou invalide.

**Solution** :
1. [Firebase Console](https://console.firebase.google.com) → ton projet
2. **Settings → Project settings → Your apps → Download google-services.json**
3. Place le fichier dans `C:/Users/crede/OneDrive/Desktop/Psold/android/app/google-services.json`
4. Commit et push

### Erreur "No matching client_info for package_name"

**Cause** : Le `applicationId` dans `build.gradle` ne correspond pas à celui du `google-services.json`.

**Solution** : Ouvre `google-services.json` et vérifie que `package_name` correspond à `com.example.psold` (ou change l'applicationId dans `android/app/build.gradle.kts`).

---

## Résumé — Checklist finale

Avant de considérer la configuration comme complète :

- [ ] Compte Codemagic créé et connecté à GitHub
- [ ] Projet pushé sur GitHub
- [ ] Keystore généré et encodé en base64
- [ ] `codemagic.yaml` présent à la racine du projet
- [ ] Groupe `supabase_credentials` configuré avec URL + clé anon
- [ ] Groupe `keystore` configuré avec `ANDROID_KEYSTORE` + passwords
- [ ] Triggers configurés (push sur main, PR updates)
- [ ] Premier build `android-release` lancé et réussi
- [ ] APKs téléchargés et testés sur téléphone
- [ ] (Optionnel) Publishing Google Play configuré

---

## Liens utiles

| Ressource | URL |
|---|---|
| Dashboard Codemagic | [app.codemagic.io](https://app.codemagic.io) |
| Documentation Codemagic | [docs.codemagic.io](https://docs.codemagic.io) |
| Play Console | [play.google.com/console](https://play.google.com/console) |
| Firebase Console | [console.firebase.google.com](https://console.firebase.google.com) |
| Supabase Dashboard | [supabase.com/dashboard](https://supabase.com/dashboard) |
| Générer keystore (keytool) | [developer.android.com](https://developer.android.com/studio/publish/app-signing) |
