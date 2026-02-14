import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/storage/secure_storage_provider.dart';
import '../domain/user_role.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final UserRole? role;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.role,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    UserRole? role,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      error: error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage;

  AuthController(this._storage) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _storage.read(key: 'auth_token');
      final roleString = await _storage.read(key: 'user_role');
      
      UserRole? role;
      if (roleString != null) {
        role = UserRole.values.firstWhere(
            (e) => e.name == roleString, orElse: () => UserRole.customer);
      }

      if (token != null) {
        state = state.copyWith(isLoading: false, isLoggedIn: true, role: role);
      } else {
        state = state.copyWith(isLoading: false, isLoggedIn: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Fake API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation
      if (password.length < 6) {
        throw Exception("Password needs to be at least 6 characters");
      }

      await _storage.write(key: 'auth_token', value: 'fake_token_123');
      // Role is not set on login if it wasn't saved before, or maybe it returns from API
      // For MVP, we'll assume they need to pick role if not locally saved, or we mock it.
      // Let's assume login doesn't return role immediately for this flow so we can show RoleChooseScreen
      // But if they have a role saved, we load it.
      
      state = state.copyWith(isLoading: false, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> register(String email, String password) async {
     state = state.copyWith(isLoading: true, error: null);
    try {
      // Fake API call
      await Future.delayed(const Duration(seconds: 1));

      await _storage.write(key: 'auth_token', value: 'fake_token_123');
      
      state = state.copyWith(isLoading: false, isLoggedIn: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setRole(UserRole role) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    await _storage.write(key: 'user_role', value: role.name);
    state = state.copyWith(isLoading: false, role: role);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = AuthState();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthController(storage);
});
