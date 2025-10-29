import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Supabase service singleton for managing Supabase client
/// 
/// Provides centralized access to Supabase client and initialization.
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient? _client;

  SupabaseService._();

  /// Get singleton instance
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Initialize Supabase
  /// 
  /// Must be called before accessing the client.
  /// Typically called in main() before runApp().
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
        debug: kDebugMode,
      );
      _client = Supabase.instance.client;
      
      if (kDebugMode) {
        debugPrint('[SupabaseService] ✅ Initialized successfully');
        debugPrint('[SupabaseService] URL: ${SupabaseConfig.supabaseUrl}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SupabaseService] ❌ Initialization failed: $e');
      }
      rethrow;
    }
  }

  /// Get Supabase client instance
  /// 
  /// Throws if Supabase has not been initialized.
  SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Check if Supabase is initialized
  bool get isInitialized => _client != null;
}
