import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/role_choose_screen.dart';
import '../../features/customer/presentation/customer_home.dart';
import '../../features/owner/presentation/owner_home.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // We mock a Listenable to notify GoRouter to refresh.
  // Ideally, we'd use a dedicated Stream or ValueNotifier that updates on auth changes.
  // However, simple ref.watch() inside a Provider doesn't automatically mean the 
  // Object returned (GoRouter) will update its internal state unless we reconstruct it 
  // or pass a Listenable.
  
  // Better approach for Riverpod + GoRouter:
  // Return a router that uses a "refreshListenable".
  // This listenable should trigger when auth state changes.
  
  final authState = ref.watch(authControllerProvider);
  
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: ValueNotifier(authState), // This forces refresh on state change
    redirect: (context, state) {
      // Re-read value to ensure we have latest (though authState above is updated)
      // Actually inside redirect we should use the state passed in or just use the closure's captured value?
      // Since the provider re-builds on authState change, this whole GoRouter is re-created.
      // Re-creating GoRouter on every auth change is okay for simple auth flips, 
      // but can lose navigation history if not careful. 
      // A more robust pattern is often desired, but for this crash "fix", re-creation is safest/simplest 
      // OR we use a static router with a dynamic listenable.
      
      // Let's use the captured `authState` from the closure since the provider rebuilds.
      final isLoggedIn = authState.isLoggedIn;
      final role = authState.role;

      final isLoggingIn = state.uri.toString() == '/login';
      final isRegistering = state.uri.toString() == '/register';

      if (!isLoggedIn) {
        if (isLoggingIn || isRegistering) return null;
        return '/login';
      }

      // Logged in
      if (isLoggingIn || isRegistering) {
        if (role == null) return '/role';
        if (role == UserRole.customer) return '/customer';
        if (role == UserRole.owner) return '/owner';
      }

      if (role == null) {
        if (state.uri.toString() == '/role') return null;
        return '/role';
      }

      if (role == UserRole.customer) {
        if (state.uri.toString().startsWith('/owner')) return '/customer';
      }

      if (role == UserRole.owner) {
        if (state.uri.toString().startsWith('/customer')) return '/owner';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleChooseScreen(),
      ),
      GoRoute(
        path: '/customer',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/owner',
        builder: (context, state) => const OwnerHomeScreen(),
      ),
    ],
  );
});
