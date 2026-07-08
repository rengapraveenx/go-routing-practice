import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/error/presentation/pages/not_found_page.dart';
import '../../../features/home/presentation/pages/home_shell_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../features/products/presentation/pages/product_detail_page.dart';
import '../../../features/products/presentation/pages/product_list_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/profile/presentation/pages/settings_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

/// Central router configuration for the app.
///
/// Key concepts demonstrated:
/// - [GoRouter] with initialLocation and errorBuilder
/// - Auth guard via [redirect] callback
/// - [StatefulShellRoute] for persistent bottom nav
/// - Path params `/products/:id`
/// - Query params `?tab=`, `?ref=`
/// - Named routes via [AppRoutes] constants
/// - [context.go] vs [context.push] vs [context.pop]
class AppRouter {
  AppRouter._();

  /// Call this once at app startup with the [AuthBloc].
  static GoRouter create(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true, // Prints route changes to console

      // ─── Auth Guard ──────────────────────────────────────────────────────
      // Called on every navigation event.
      // Returns a redirect path or null (no redirect).
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isLoading = authState is AuthLoading || authState is AuthInitial;

        final location = state.matchedLocation;

        // Public routes — no auth needed
        final isPublic = location == AppRoutes.splash ||
            location == AppRoutes.onboarding ||
            location == AppRoutes.login ||
            location == AppRoutes.register;

        // Still checking auth — stay on splash
        if (isLoading) return null;

        // Not logged in + trying to access protected route
        if (!isAuthenticated && !isPublic) {
          return AppRoutes.login;
        }

        // Logged in + on login/register → go to home
        if (isAuthenticated &&
            (location == AppRoutes.login ||
                location == AppRoutes.register)) {
          return AppRoutes.products;
        }

        return null; // No redirect
      },

      // ─── Error / 404 ─────────────────────────────────────────────────────
      errorBuilder: (context, state) =>
          NotFoundPage(error: state.error),

      // ─── Routes ──────────────────────────────────────────────────────────
      routes: [
        // 1. Splash
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // 2. Onboarding
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),

        // 3. Login
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),

        // 4. Register (pushed on top of login)
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterPage(),
        ),

        // 5. Home — StatefulShellRoute (persistent bottom nav)
        //    Each branch maintains its own Navigator stack independently.
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              HomeShellPage(navigationShell: navigationShell),
          branches: [
            // ── Branch 0: Products ─────────────────────────────────────
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.products,
                  builder: (context, state) => const ProductListPage(),
                  routes: [
                    // Nested route: /home/products/:id
                    // Demonstrates path parameters
                    GoRoute(
                      path: ':id', // matches /home/products/42
                      builder: (context, state) {
                        // Extract path param
                        final id = state.pathParameters['id']!;
                        return ProductDetailPage(productId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),

            // ── Branch 1: Cart ─────────────────────────────────────────
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.cart,
                  builder: (context, state) => const CartPage(),
                ),
              ],
            ),

            // ── Branch 2: Profile ──────────────────────────────────────
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfilePage(),
                  routes: [
                    // Sub-route: /home/profile/settings
                    // Demonstrates nested routes + query params (?tab=)
                    GoRoute(
                      path: 'settings', // matches /home/profile/settings
                      builder: (context, state) => const SettingsPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
