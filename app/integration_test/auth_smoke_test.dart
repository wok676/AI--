// 认证主流程冒烟集成测试(QA 自动化基座示例)。
//
// 连**本地真后端**(--dart-define=API_BASE_URL=http://localhost:3000/api,
// 真机经 `adb reverse tcp:3000 tcp:3000` 直连宿主机),用 [TestKeys] 定位控件,
// 跑最小闭环:
//   注册(勾选同意)→ 进主页 → 退出 → 用同账号登录 → 再次进主页 → 清理(注销账号)。
//
// 运行:
//   flutter test integration_test/auth_smoke_test.dart -d <device> \
//     --dart-define=API_BASE_URL=http://localhost:3000/api
//
// 说明:
// - 测试账号 `qa_it_<时间戳>@test.local` 每次唯一,避免与历史数据冲突;
//   口令仅用于本地测试,绝不进生产路径,不含真实 PII。
// - 用例末尾**注销账号**做自清理(走 app 内注销二次确认弹窗),不留脏数据。

import 'package:calorie_app/app.dart';
import 'package:calorie_app/common/test_keys.dart';
import 'package:calorie_app/features/auth/auth_screen.dart';
import 'package:calorie_app/features/home/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 唯一测试账号(本地测试专用口令,满足后端 ≥8 含字母+数字)。
  final String email =
      'qa_it_${DateTime.now().millisecondsSinceEpoch}@test.local';
  const String password = 'QaItPass123';

  /// 反复 pump 直到 [finder] 命中或超时(承载真网络往返,不依赖固定时长)。
  Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 300));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for: $finder');
  }

  Finder byKey(String key) => find.byKey(ValueKey<String>(key));

  /// 滚动使目标可见后再点(资料页底部的退出/注销按钮在小屏需滚动)。
  /// 用固定 pump 而非 pumpAndSettle:页面含骨架 shimmer 等常驻动画,settle 会一直不收敛。
  Future<void> tapWhenVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(finder);
  }

  testWidgets('register -> home -> logout -> login -> home (+ cleanup)', (
    WidgetTester tester,
  ) async {
    void step(String s) => debugPrint('IT_STEP: $s');

    await tester.pumpWidget(const ProviderScope(child: CalorieApp()));

    // 启动后由 router redirect:未登录 → 登录页。
    step('await auth screen');
    await pumpUntil(tester, find.byType(AuthScreen));

    // ── 1. 切到注册模式 ──
    step('tap mode switch');
    await tester.tap(byKey(TestKeys.authModeSwitch));
    await tester.pump(const Duration(milliseconds: 400));
    // 注册态:同意勾选框出现。
    expect(byKey(TestKeys.consentCheckbox), findsOneWidget);

    // ── 2. 填邮箱/密码 ──
    step('enter email/password');
    await tester.enterText(byKey(TestKeys.loginEmailField), email);
    await tester.enterText(byKey(TestKeys.loginPasswordField), password);
    await tester.pump(const Duration(milliseconds: 200));

    // ── 3. 勾选知情同意(默认未勾,勾选后提交按钮才可用)──
    step('tap consent');
    await tester.tap(byKey(TestKeys.consentCheckbox));
    await tester.pump(const Duration(milliseconds: 200));

    // ── 4. 提交注册 ──
    step('submit register');
    await tester.tap(byKey(TestKeys.loginSubmitBtn));

    // ── 5. 注册成功 → router 自动进 Today 主页 ──
    step('await today after register');
    await pumpUntil(tester, byKey(TestKeys.todayScreen));
    expect(find.byType(TodayScreen), findsOneWidget);
    expect(byKey(TestKeys.navBar), findsOneWidget);

    // ── 6. 切到资料 Tab → 退出登录 ──
    step('go profile, logout');
    await tester.tap(byKey(TestKeys.tabProfile));
    await pumpUntil(tester, byKey(TestKeys.logoutBtn));
    await tapWhenVisible(tester, byKey(TestKeys.logoutBtn));
    await pumpUntil(tester, byKey(TestKeys.logoutConfirmBtn));
    await tester.tap(byKey(TestKeys.logoutConfirmBtn));

    // 退出后回登录页。
    step('await auth after logout');
    await pumpUntil(tester, find.byType(AuthScreen));

    // ── 7. 用同账号登录(此时为登录模式,无需勾选同意)──
    step('login same account');
    await tester.enterText(byKey(TestKeys.loginEmailField), email);
    await tester.enterText(byKey(TestKeys.loginPasswordField), password);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(byKey(TestKeys.loginSubmitBtn));

    // ── 8. 登录成功 → 再次进 Today ──
    step('await today after login');
    await pumpUntil(tester, byKey(TestKeys.todayScreen));
    expect(find.byType(TodayScreen), findsOneWidget);

    // ── 9. 自清理:进资料 → 注销账号(二次验密)避免脏数据 ──
    step('go profile, delete account');
    await tester.tap(byKey(TestKeys.tabProfile));
    await pumpUntil(tester, byKey(TestKeys.deleteAccountBtn));
    await tapWhenVisible(tester, byKey(TestKeys.deleteAccountBtn));
    await pumpUntil(tester, byKey(TestKeys.deleteConfirmPasswordField));
    await tester.enterText(
      byKey(TestKeys.deleteConfirmPasswordField),
      password,
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(byKey(TestKeys.deleteConfirmBtn));

    // 注销成功 → 本地凭证清除 → 回登录页(闭环验证彻底登出)。
    step('await auth after delete');
    await pumpUntil(tester, find.byType(AuthScreen));
    expect(find.byType(AuthScreen), findsOneWidget);
    step('DONE');
  });
}
