import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/placeholder_screens.dart';
import '../features/shell/app_shell.dart';

/// 路由路径常量(避免散落字符串)。
abstract final class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String auth = '/auth';
  static const String today = '/today';
  static const String history = '/history';
  static const String profile = '/profile';
}

final _rootKey = GlobalKey<NavigatorState>();

/// 导航骨架(UI §4.1):未登录栈(Splash/Auth)+ 已登录 3-Tab Shell。
/// 鉴权重定向(已登录跳过 auth / 未登录拦截业务)由 T5 接入 auth 状态后补 redirect。
final routerProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (BuildContext context, GoRouterState state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.today,
                builder: (BuildContext context, GoRouterState state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.history,
                builder: (BuildContext context, GoRouterState state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
