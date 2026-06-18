// 识别闭环冒烟集成测试(QA 自动化:取代 adb 手点驱动)。
//
// 连**本地真后端**(--dart-define=API_BASE_URL=http://localhost:3000/api,
// 真机经 `adb reverse tcp:3000 tcp:3000` 直连),用 [TestKeys] 定位控件,
// 跑文字识别完整闭环:
//   注册(勾选同意)→ 今日 → 记一餐 → 文字 → 输入 → 识别 → 确认页 → 保存
//   → 回今日 → 注销自清理。
//
// 前置:后端已配 ANTHROPIC_API_KEY/BASE_URL(识别需真实 AI 调用);否则识别会
// 失败、无法到达确认页(那是另一条降级路径,见 capture 流程)。
//
// 运行:
//   flutter test integration_test/recognition_smoke_test.dart -d <device> \
//     --dart-define=API_BASE_URL=http://localhost:3000/api
//
// 说明:测试账号 qa_it_recog_<时间戳>@test.local 每次唯一,末尾注销避免脏数据;
//   口令仅本地测试用,绝不进生产路径、不含真实 PII。

import 'package:calorie_app/app.dart';
import 'package:calorie_app/common/test_keys.dart';
import 'package:calorie_app/features/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final String email =
      'qa_it_recog_${DateTime.now().millisecondsSinceEpoch}@test.local';
  const String password = 'QaItPass123';

  Finder byKey(String key) => find.byKey(ValueKey<String>(key));

  /// 反复 pump 直到 [finder] 命中或超时(承载真网络/AI 往返,不依赖固定时长)。
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

  /// 反复 pump 直到 [finder] **消失**(用于"离开某页"的可靠信号)。
  Future<void> pumpUntilGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 300));
      if (finder.evaluate().isEmpty) return;
    }
    fail('Timed out waiting for disappearance of: $finder');
  }

  /// 滚动可见后再点(确认页保存键在长列表底部需滚动)。
  /// 用固定 pump 而非 pumpAndSettle:页面含骨架 shimmer 等常驻动画,settle 不收敛。
  Future<void> tapWhenVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(finder);
  }

  testWidgets(
    'register -> record text meal -> recognize -> confirm -> save (+ cleanup)',
    (WidgetTester tester) async {
      void step(String s) => debugPrint('IT_STEP: $s');

      await tester.pumpWidget(const ProviderScope(child: CalorieApp()));

      // ── 1. 注册(未登录 → 登录页 → 切注册 → 填表 → 勾同意 → 提交)──
      step('await auth screen');
      await pumpUntil(tester, find.byType(AuthScreen));
      await tester.tap(byKey(TestKeys.authModeSwitch));
      await tester.pump(const Duration(milliseconds: 400));
      expect(byKey(TestKeys.consentCheckbox), findsOneWidget);
      await tester.enterText(byKey(TestKeys.loginEmailField), email);
      await tester.enterText(byKey(TestKeys.loginPasswordField), password);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(byKey(TestKeys.consentCheckbox));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(byKey(TestKeys.loginSubmitBtn));

      step('await today after register');
      await pumpUntil(tester, byKey(TestKeys.todayScreen));

      // ── 2. 记一餐 ──
      // 空态(新账号当日无记录):FAB 被刻意隐藏(避免与中部 CTA 双主操作),
      //   须点空态视图**内部的动作按钮** stateEmptyAction(其 key 在按钮本身,可点中);
      //   todayEmptyCta 的 key 在整张 EmptyView 上,tap 其中心会落在图标/文案区而点不到按钮。
      // 有数据态:点右下角 FAB recordMealBtn。两者必有其一。
      step('open capture method sheet');
      final Finder emptyAction = byKey(TestKeys.stateEmptyAction);
      final Finder fab = byKey(TestKeys.recordMealBtn);
      await tester.tap(emptyAction.evaluate().isNotEmpty ? emptyAction : fab);
      await pumpUntil(tester, byKey(TestKeys.captureOptionText));

      // ── 3. 选「文字」→ 输入 → 识别 ──
      step('choose text capture');
      await tester.tap(byKey(TestKeys.captureOptionText));
      await pumpUntil(tester, byKey(TestKeys.captureTextField));
      await tester.enterText(
        byKey(TestKeys.captureTextField),
        'two boiled eggs and a bowl of white rice',
      );
      await tester.pump(const Duration(milliseconds: 200));
      step('submit recognize');
      // 用 tapWhenVisible(ensureVisible + 点击):识别按钮在 Expanded 文本框下方,
      // 直接 tap 其中心偶发 warnIfMissed(命中坐标落在视口边缘),先滚动确保可见再点。
      await tapWhenVisible(tester, byKey(TestKeys.captureRecognizeBtn));

      // ── 4. 等确认页(真实 AI 调用 + 中转站往返,放宽到 60s)──
      step('await confirm screen');
      await pumpUntil(
        tester,
        byKey(TestKeys.recognitionSaveBtn),
        timeout: const Duration(seconds: 60),
      );

      // ── 5. 保存 → 回今日(确认页栈弹出)──
      step('save meal');
      await tapWhenVisible(tester, byKey(TestKeys.recognitionSaveBtn));
      // 保存成功后确认页 context.pop() 弹出 → 回到今日。
      // 注意:todayScreen 由 StatefulShellRoute.indexedStack 常驻挂载,push 确认页时它仍在树中,
      //   故不能用"todayScreen 出现"判断已返回;改等**保存键消失**(= 确认页已弹出)作为可靠信号。
      step('await leave confirm after save');
      await pumpUntilGone(tester, byKey(TestKeys.recognitionSaveBtn));
      // 闭环完成:已离开确认页,今日页仍在(未崩溃)。
      expect(byKey(TestKeys.todayScreen), findsOneWidget);

      // ── 6. 自清理:资料 → 注销(二次验密)──
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
      await pumpUntil(tester, find.byType(AuthScreen));
      expect(find.byType(AuthScreen), findsOneWidget);
      step('DONE');
    },
  );
}
