import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PsoldSupabaseClient {
  PsoldSupabaseClient._();

  static final PsoldSupabaseClient _instance = PsoldSupabaseClient._();

  factory PsoldSupabaseClient() => _instance;

  static Supabase get instance => Supabase.instance;

  Future<void> initialize() async {
    String supabaseUrl = '';
    String supabaseAnonKey = '';

    try {
      supabaseUrl = const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: '',
      );
      supabaseAnonKey = const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: '',
      );
    } catch (e) {
      debugPrint('Error reading Supabase environment variables: $e');
    }

    if (supabaseUrl.isEmpty) {
      supabaseUrl = 'https://dsflswhxvjnvkedhrynd.supabase.co';
    }
    if (supabaseAnonKey.isEmpty) {
      supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRzZmxzd2h4dmpudmtlZGhyeW5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzNDU2NjEsImV4cCI6MjA5MzkyMTY2MX0.wlyrkJ2ZDv0-z4S_EMvYFOvS7Eb6Y-cus9Y6CfP7mRA';
    }

    debugPrint('Initializing Supabase with URL: $supabaseUrl');

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode,
    );

    debugPrint('Supabase initialized successfully');
  }
}