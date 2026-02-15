import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/auth_repository.dart';
import '../domain/user_role.dart';
import '../domain/user_profile.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final UserRole? role;
  final String? error;
  final UserProfile? userProfile;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.role,
    this.error,
    this.userProfile,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    UserRole? role,
    String? error,
    UserProfile? userProfile,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      error: error,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState()) {
    _init();
  }

  void _init() {
    _authRepository.authStateChanges.listen((User? user) async {
      if (user == null) {
        state = AuthState(isLoggedIn: false);
      } else {
        // User is logged in, fetch profile for role
        state = state.copyWith(isLoading: true);
        try {
          final profile = await _authRepository.getUserProfile(user.uid);
          if (profile != null) {
             state = state.copyWith(
              isLoading: false,
              isLoggedIn: true,
              role: profile.role,
              userProfile: profile,
            );
          } else {
            // Profile missing? create one or handle error. 
            // For now, assume it exists or fallback to customer.
             state = state.copyWith(
              isLoading: false,
              isLoggedIn: true,
              role: UserRole.customer, // Default fallback
            );
          }
        } catch (e) {
            state = state.copyWith(isLoading: false, error: e.toString());
        }
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.signIn(email, password);
      // State updates via stream listener
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.signUp(email: email, password: password);
      // State updates via stream listener
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setRole(UserRole role) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _authRepository.updateRole(user.uid, role);
        // Refresh profile
        final profile = await _authRepository.getUserProfile(user.uid);
        state = state.copyWith(
          isLoading: false,
          role: role,
          userProfile: profile,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});
