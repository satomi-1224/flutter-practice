import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/pages/product/product_page.dart';
import 'package:flutter_app/pages/product/detail/product_detail_page.dart';
import 'package:flutter_app/pages/auth/login/login_page.dart';
import 'package:flutter_app/pages/cart/cart_page.dart';
import 'package:flutter_app/pages/setting/setting_page.dart';
import 'package:flutter_app/pages/order/order_page.dart';
import 'package:flutter_app/pages/order/detail/order_detail_page.dart';
import 'package:flutter_app/pages/checkout/checkout_page.dart';
import 'package:flutter_app/pages/checkout/success/checkout_success_page.dart';
import 'package:flutter_app/pages/profile/profile_edit_page.dart';
import 'package:flutter_app/widgets/layouts/scaffold_with_nav.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/auth/login',
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailPage(productId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrderPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return OrderDetailPage(orderId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingPage(),
            routes: [
              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileEditPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
        routes: [
          GoRoute(
            path: 'success',
            builder: (context, state) => const CheckoutSuccessPage(),
          ),
        ],
      ),
    ],
  );
}
