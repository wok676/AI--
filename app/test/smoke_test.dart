import 'package:calorie_app/app.dart';
import 'package:calorie_app/l10n/supported_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots into splash without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CalorieApp()));
    await tester.pump();
    // 根渲染成功即说明 ErrorBoundary/i18n/router 接线无致命错误。
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('supported locales cover the 12 PRD languages with en fallback', () {
    expect(SupportedLocales.all.length, 12);
    expect(SupportedLocales.fallback, const Locale('en'));
    expect(SupportedLocales.isRtl(const Locale('ar')), isTrue);
    expect(SupportedLocales.isRtl(const Locale('ur')), isTrue);
    expect(SupportedLocales.isRtl(const Locale('ja')), isFalse);
    expect(SupportedLocales.isRtl(const Locale('ko')), isFalse);
    // 不支持的 locale 回退 en。
    expect(SupportedLocales.resolve(const Locale('de')), const Locale('en'));
  });
}
