import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../pages/auth/login_page.dart';
import '../pages/home/home_page.dart';
import '../pages/listing/listing_page.dart';
import '../pages/mypage/mypage_page.dart';
import '../pages/notification/notification_page.dart';
import '../pages/product/product_detail_page.dart';
import '../pages/root/scaffold_with_bottom_nav_bar.dart';
import '../pages/search/search_page.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _listingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'listing');
final _notificationNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'notification');
final _mypageNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'mypage');

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Search
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          // Listing (Sell)
          StatefulShellBranch(
            navigatorKey: _listingNavigatorKey,
            routes: [
              GoRoute(
                path: '/sell',
                builder: (context, state) => const ListingPage(),
              ),
            ],
          ),
          // Notifications
          StatefulShellBranch(
            navigatorKey: _notificationNavigatorKey,
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationPage(),
              ),
            ],
          ),
          // My Page
          StatefulShellBranch(
            navigatorKey: _mypageNavigatorKey,
            routes: [
              GoRoute(
                path: '/mypage',
                builder: (context, state) => const MyPagePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
