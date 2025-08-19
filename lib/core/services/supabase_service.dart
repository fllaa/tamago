import 'package:supabase/supabase.dart';
import 'package:tamago/core/config/flavor_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static late SupabaseClient _supabase;

  static SupabaseService get instance {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  SupabaseService._internal() {
    final config = FlavorConfig.instance;
    _supabase = SupabaseClient(
      config.supabaseUrl,
      config.supabaseAnonKey,
    );
  }

  SupabaseClient get client => _supabase;

  // Helper method to get the current user
  Map<String, dynamic>? getCurrentUser() {
    return _supabase.auth.currentUser?.userMetadata;
  }

  // Helper method to check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Helper method to sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
