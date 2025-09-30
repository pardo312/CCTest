import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    return Supabase.instance.client;
  } catch (e) {
    // Supabase not initialized (e.g., missing credentials)
    return null;
  }
});

final authStateProvider = StreamProvider<AuthState?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const Stream.empty();
  return client.auth.onAuthStateChange.map((data) => data.session != null ? data : null);
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state?.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

class AuthService {
  final SupabaseClient? _client;

  AuthService(this._client);

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      throw Exception('Supabase client not initialized');
    }

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    if (_client == null) {
      throw Exception('Supabase client not initialized');
    }

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    if (_client == null) return;
    await _client.auth.signOut();
  }

  User? get currentUser => _client?.auth.currentUser;
  Session? get currentSession => _client?.auth.currentSession;
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});