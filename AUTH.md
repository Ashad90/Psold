# AUTH.md — Psold Authentication

## Overview

This document details the authentication implementation in Psold, covering email/password and Google OAuth via Supabase.

---

## Technologies Used

| Technology | Version | Purpose |
|------------|---------|---------|
| `supabase_flutter` | ^2.12.4 | Supabase client SDK |
| `flutter_riverpod` | ^2.5.0 | State management |
| `go_router` | ^14.0.0 | Navigation with auth guards |
| `hive_flutter` | ^1.1.0 | Local storage (settings) |

---

## Authentication Methods

### 1. Email/Password

**Supabase Method:** `supabase.auth.signInWithPassword()` and `supabase.auth.signUp()`

**Flow:**
1. User enters email + password in `LoginScreen`
2. On login: `signInWithPassword(email, password)` → redirect to `/feed` on success
3. On register: `signUp(email, password)` → create profile in `profiles` table with role

**Key Files:**
- `lib/features/auth/presentation/login_screen.dart:45`
- `lib/features/auth/presentation/register_merchant_screen.dart`
- `lib/features/auth/presentation/register_client_screen.dart`

**Registration Logic (auth_provider.dart):**
```dart
// Sign up creates user + profile
final response = await supabase.auth.signUp(email: email, password: password);
if (response.user != null) {
  await supabase.from('profiles').insert({
    'id': response.user!.id,
    'role': role, // 'client' or 'merchant'
    'display_name': displayName,
    'whatsapp': whatsapp,
    'city': city,
  });
}
```

---

### 2. Google OAuth

**Supabase Method:** `supabase.auth.signInWithOAuth(OAuthProvider.google)`

**Flow:**
1. User clicks "Continuer avec Google" in `LoginScreen`
2. Opens Google sign-in in browser/app
3. Redirects to `io.supabase.psold://callback` (deep link)
4. Router checks if profile exists
5. If no profile → redirect to `/google-profile-setup` for profile completion

**Key Files:**
- `lib/features/auth/presentation/login_screen.dart:66-83`
- `lib/features/auth/presentation/google_profile_setup_screen.dart:30-63`
- `lib/core/router.dart:252-266`

**Router Guard Logic (router.dart:252-266):**
```dart
final isGoogleUser = session?.user.appMetadata['provider'] == 'google';

if (isLoggedIn && profile == null && isGoogleUser) {
  return '/google-profile-setup';
}
```

**Callback URL:** `io.supabase.psold://callback`

---

## Supabase Configuration

### Initialization

**File:** `lib/core/supabase_client.dart`

```dart
await Supabase.initialize(
  url: supabaseUrl,
  anonKey: supabaseAnonKey,
  debug: kDebugMode,
);
```

**Environment Variables (--dart-define):**
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

**Fallback Values:** Hardcoded in `supabase_client.dart:30-35` for development.

---

## Database Schema

### Table: `profiles`

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| `id` | uuid | Yes | References `auth.users.id` |
| `role` | text | Yes | `'client'` or `'merchant'` |
| `display_name` | text | Yes | User/shop name |
| `whatsapp` | text | No | E.164 format (`+23600000000`) |
| `city` | text | No | User location |
| `avatar_url` | text | No | Google avatar URL |
| `last_active` | timestamp | No | Auto-updated on login |

**RLS Policy Required:**
- Users can read/write own profile
- Public can read all profiles (for product attribution)

---

## Auth State Management

### Providers (router.dart)

```dart
// Stream of auth state changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

// Current user profile (null if not logged in)
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserProfile?>
```

### AuthNotifier (auth_provider.dart)

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  Future<void> signInWithEmailPassword(String email, String password)
  Future<void> signUpWithEmailPassword({...})
  Future<void> signUpClientWithEmailPassword({...})
  Future<void> signInWithGoogle()
  Future<void> signOut()
}
```

---

## Router Auth Guards

**File:** `lib/core/router.dart:240-282`

| Condition | Action |
|-----------|--------|
| Not logged in + trying to access protected route | Redirect to `/login` |
| Logged in + on auth route (`/login`, `/register`) | Redirect to `/feed` |
| Logged in + Google user + no profile | Redirect to `/google-profile-setup` |
| Logged in + no profile (email) | Redirect to `/onboarding` |
| Logged in + profile + 7+ days inactive | Auto sign-out |

---

## Supabase Console Setup

### 1. Enable Google OAuth

1. Go to **Authentication → Providers → Google**
2. Enable provider
3. Add allowed domains (or leave empty for all)
4. Set redirect URL: `io.supabase.psold://callback`
5. Get Client ID and Secret from Google Cloud Console

### 2. Environment Variables in Supabase

Add these in **Settings → API**:
- Not needed for client (uses anon key)
- Edge Functions may need `GEMINI_API_KEY`

### 3. Deep Link Configuration

**iOS (Info.plist):**
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.psold</string>
    </array>
  </dict>
</array>
```

**Android (AndroidManifest.xml):**
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="io.supabase.psold" />
</intent-filter>
```

---

## Sign Out

```dart
// Via router
final notifier = ref.read(currentUserProvider.notifier);
await notifier.signOut();

// Or directly
await supabase.auth.signOut();
```

---

## Error Handling

| Error | Handling |
|-------|----------|
| Invalid credentials | Show SnackBar: "Identifiants incorrects" |
| Network error | Show SnackBar with error message |
| Google OAuth failure | Show SnackBar: "Erreur Google: $e" |
| Profile creation failure | Logged, user redirected to onboarding |

---

## Testing

```bash
# Run auth tests
flutter test test/auth_test.dart

# Run all tests
flutter test
```

---

## Dependencies to Add

None — `supabase_flutter` is already in `pubspec.yaml`.

---

## Google Cloud Console Setup

To enable Google OAuth, you need:

1. Create project in [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Google+ API** or **Gmail API**
3. Create **OAuth 2.0 credentials** (Web client or iOS/Android)
4. Set authorized redirect URI to Supabase callback:
   ```
   https://[project-ref].supabase.co/auth/v1/callback
   ```
5. Copy Client ID and Secret to Supabase Auth → Google provider