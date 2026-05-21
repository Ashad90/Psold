import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/router.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  Future<void> signInWithEmailPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        state = state.copyWith(isLoading: false, error: 'Identifiants incorrects');
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    required String whatsapp,
    required String city,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('profiles').upsert({
          'id': response.user!.id,
          'role': role,
          'display_name': displayName,
          'whatsapp': whatsapp,
          'city': city,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUpClientWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    String? whatsapp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('profiles').upsert({
          'id': response.user!.id,
          'role': 'client',
          'display_name': displayName,
          if (whatsapp != null && whatsapp.isNotEmpty) 'whatsapp': whatsapp,
        });
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signOut();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.psold://callback',
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}