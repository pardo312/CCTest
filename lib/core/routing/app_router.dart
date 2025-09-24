import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/marketplace_core/screens/marketplace_home.dart';
import '../../modules/marketplace_core/screens/product_detail.dart';
import '../../modules/marketplace_core/screens/category_listing.dart';
import '../../modules/marketplace_core/screens/cart_screen.dart';
import '../../modules/auth/screens/login_screen.dart';
import '../../modules/auth/screens/register_screen.dart';
import '../../modules/dashboard/screens/user_dashboard.dart';
import '../../modules/dashboard/screens/order_history.dart';
import '../../modules/payment/screens/pricing_screen.dart';
import '../../modules/payment/screens/billing_dashboard.dart';
import '../widgets/app_shell.dart';
import '../widgets/error_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MarketplaceHome(),
            routes: [
              GoRoute(
                path: 'product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetail(productId: id);
                },
              ),
              GoRoute(
                path: 'category/:slug',
                builder: (context, state) {
                  final slug = state.pathParameters['slug']!;
                  return CategoryListing(categorySlug: slug);
                },
              ),
              GoRoute(
                path: 'cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/auth/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/auth/register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const UserDashboard(),
            redirect: (context, state) => authGuard(context, state),
            routes: [
              GoRoute(
                path: 'orders',
                builder: (context, state) => const OrderHistory(),
              ),
              GoRoute(
                path: 'billing',
                builder: (context, state) => const BillingDashboard(),
              ),
            ],
          ),
          GoRoute(
            path: '/pricing',
            builder: (context, state) => const PricingScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );

  static String? authGuard(BuildContext context, GoRouterState state) {
    // TODO: Implement actual auth check using Supabase
    final isLoggedIn = false; // Replace with actual auth check

    if (!isLoggedIn) {
      return '/auth/login?redirect=${state.uri.path}';
    }
    return null;
  }

  static String? sellerGuard(BuildContext context, GoRouterState state) {
    // TODO: Implement seller permission check
    final isLoggedIn = false; // Replace with actual auth check
    final isSeller = false; // Replace with actual seller check

    if (!isLoggedIn) {
      return '/auth/login?redirect=${state.uri.path}';
    }
    if (!isSeller) {
      return '/dashboard';
    }
    return null;
  }
}