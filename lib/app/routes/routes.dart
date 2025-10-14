// Define app-wide router configuration using go_router with a stateful shell
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/app/app.dart';
import 'package:keyper/app/view/app_shell.dart';
import 'package:keyper/call_log/view/call_log_page.dart';
import 'package:keyper/dashboard/dashboard.dart';
import 'package:keyper/profile/profile.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboardNavigator');

final GlobalKey<NavigatorState> _callLogNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'callLogNavigator');

final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profileNavigator');

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  onException: (_, GoRouterState state, GoRouter router) {
    router.go('/404', extra: state.uri.toString());
  },
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            // Return the widget that implements the custom shell (in this case
            // using a BottomNavigationBar). The StatefulNavigationShell is
            // passed
            // to be able access the state of the shell and to navigate to other
            // branches in a stateful way.
            return AppShell(navigationShell: navigationShell);
          },
      branches: [
        StatefulShellBranch(
          navigatorKey: _dashboardNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _callLogNavigatorKey,
          routes: [
            GoRoute(
              path: '/call_log',
              name: 'call_log',
              builder: (context, state) => const CallLogPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/404',
      builder: (BuildContext context, GoRouterState state) {
        return NotFoundScreen(uri: state.extra as String? ?? '');
      },
    ),
  ],
);
