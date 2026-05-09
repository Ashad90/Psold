import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> signInWithEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signInWithOtp(email: email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithPhone(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signInWithOtp(phone: phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUpMerchant({
    required String email,
    required String displayName,
    required String whatsapp,
    required String city,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signInWithOtp(email: email);
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase.from('profiles').insert({
          'id': userId,
          'role': 'merchant',
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

  Future<void> signUpClient({
    required String email,
    required String displayName,
    String? whatsapp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signInWithOtp(email: email);
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase.from('profiles').insert({
          'id': userId,
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
}