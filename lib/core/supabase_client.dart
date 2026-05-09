import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton Supabase client initialization
class PsoldSupabaseClient {
  PsoldSupabaseClient._();

  static final PsoldSupabaseClient _instance = PsoldSupabaseClient._();

  factory PsoldSupabaseClient() => _instance;

  static Supabase get instance => Supabase.instance;

  /// Initialize Supabase with URL and anon key
  /// These should be provided via --dart-define or environment variables
  Future<void> initialize() async {
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'YOUR_SUPABASE_URL_HERE',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
    );

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
