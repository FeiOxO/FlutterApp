import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/features/auth/view_models/auth_provider.dart';
import '../ui/features/auth/views/login_screen.dart';
import '../ui/features/auth/views/register_screen.dart';
import '../ui/features/auth/views/forgot_password_screen.dart';
import '../ui/features/dashboard/views/dashboard_screen.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthProvider auth) {
  return GoRouter(
    navigatorKey: _navigatorKey,
    refreshListenable: auth,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = auth.isLoggedIn;
      final isLoading = auth.isLoading;
      final isLoggingOut = auth.isLoggingOut;
      final location = state.uri.toString();

      if (isLoading || isLoggingOut) return null;

      final isOnAuthPage = location == '/' || location == '/register' || location == '/forgot-password';

      if (!isLoggedIn && !isOnAuthPage) {
        return '/';
      }

      if (isLoggedIn && isOnAuthPage) {
        return '/dashboard';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('页面未找到: ${state.error?.message ?? state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
}
