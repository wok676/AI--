import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/auth_screen.dart';
import '../features/capture/recognition_confirm_screen.dart';
import '../features/capture/text_capture_screen.dart';
import '../features/goal/goal_screen.dart';
import '../features/history/history_screen.dart';
import '../features/home/today_screen.dart';
import '../features/legal/legal_screen.dart';
import '../features/profile/language_picker_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/splash/splash_screen.dart';

/// 路由路径常量(避免散落字符串)。
abstract final class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String auth = '/auth';
  static const String today = '/today';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String textCapture = '/capture/text';
  static const String recognitionConfirm = '/capture/confirm';
  static const String goal = '/goal';
  static const String language = '/profile/language';
  static const String legalTerms = '/legal/terms';
  static const String legalPrivacy = '/legal/privacy';
}

final _rootKey = GlobalKey<NavigatorState>();

/// 把 Riverpod 的 [AuthState] 变化转成 [Listenable],驱动 go_router 重算 redirect。
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(authControllerProvider, (AuthState? _, AuthState _) => notifyListeners());
  }
}

/// 导航骨架(UI §4.1)+ 鉴权重定向(UI §4.2)。
/// - status 未知:停在 splash(恢复会话中,不闪跳);
/// - 已登录访问 splash/auth → 跳 Today;
/// - 未登录访问受保护区 → 跳 Auth。
final routerProvider = Provider<GoRouter>((Ref ref) {
  final _AuthRefresh refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState auth = ref.read(authControllerProvider);
      final String loc = state.matchedLocation;

      // 法律文档页(用户协议/隐私政策)为公开页:无论登录与否、会话是否恢复完成,
      // 都必须可直达(注册页知情同意链接 + 个人中心入口都会进这里),不参与鉴权重定向。
      final bool isLegal =
          loc == AppRoutes.legalTerms || loc == AppRoutes.legalPrivacy;
      if (isLegal) return null;

      // 会话恢复中:停在 splash,等解析完成再跳。
      if (!auth.isResolved) {
        return loc == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // 已解析:splash 仅是过渡页,绝不能停留,必须按登录态离开
      // (修复:未登录停 splash 时旧逻辑返回 null 导致永久卡启动页)。
      if (auth.isAuthenticated) {
        // 已登录却停在游客区(splash/auth)→ 进主 Shell;受保护页放行。
        final bool atGuest = loc == AppRoutes.splash || loc == AppRoutes.auth;
        return atGuest ? AppRoutes.today : null;
      }
      // 未登录:停在登录页放行;其余(含 splash)一律回登录页。
      return loc == AppRoutes.auth ? null : AppRoutes.auth;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (BuildContext context, GoRouterState state) => const AuthScreen(),
      ),
      // 录入文字页(root 栈,带返回)。
      GoRoute(
        path: AppRoutes.textCapture,
        builder: (BuildContext context, GoRouterState state) => const TextCaptureScreen(),
      ),
      // AI 识别结果确认页:extra 携带 RecognitionResult + 来源。
      GoRoute(
        path: AppRoutes.recognitionConfirm,
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          if (extra is RecognitionConfirmArgs) {
            return RecognitionConfirmScreen(args: extra);
          }
          // 防御:无参数直接回 Today(绝不崩溃)。
          return const TodayScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.goal,
        builder: (BuildContext context, GoRouterState state) => const GoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (BuildContext context, GoRouterState state) => const LanguagePickerScreen(),
      ),
      // 应用内法律文档(公开,游客/已登录均可访问)。
      GoRoute(
        path: AppRoutes.legalTerms,
        builder: (BuildContext context, GoRouterState state) => const TermsScreen(),
      ),
      GoRoute(
        path: AppRoutes.legalPrivacy,
        builder: (BuildContext context, GoRouterState state) => const PrivacyScreen(),
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
