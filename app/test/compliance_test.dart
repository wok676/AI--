import 'package:calorie_app/common/widgets/progress_ring.dart';
import 'package:calorie_app/compliance/consent_gate.dart';
import 'package:calorie_app/l10n/app_localizations.dart';
import 'package:calorie_app/l10n/message_key.dart';
import 'package:calorie_app/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// 内存版安全存储,供合规闸门单测(不触原生 Keychain)。
class _FakeSecureBackend extends SecureStorage {
  final Map<String, String> _m = <String, String>{};
  @override
  Future<String?> read(String key) async => _m[key];
  @override
  Future<void> write(String key, String value) async => _m[key] = value;
  @override
  Future<void> delete(String key) async => _m.remove(key);
  @override
  Future<void> deleteAll() async => _m.clear();
}

Widget _wrap(Widget child, {required Locale locale}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const <LocalizationsDelegate<Object>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Privacy consent gate (PRD §4.1/§4.7)', () {
    test('default not consented; third-party SDK init blocked until granted', () async {
      final ConsentGate gate = ConsentGate(_FakeSecureBackend());
      // 默认未同意 → SDK 闸门拦截。
      expect(await gate.hasConsented(), isFalse);
      bool sdkInitialized = false;
      await gate.runIfConsented(() async => sdkInitialized = true);
      expect(sdkInitialized, isFalse, reason: '同意前必须静默拦截第三方 SDK');

      // 主动勾选同意后才放行。
      await gate.grantConsent(version: '1.0');
      expect(await gate.hasConsented(), isTrue);
      await gate.runIfConsented(() async => sdkInitialized = true);
      expect(sdkInitialized, isTrue);

      // 撤回(注销)后再次拦截。
      await gate.revokeConsent();
      expect(await gate.hasConsented(), isFalse);
    });
  });

  group('messageKey → i18n (API §0.3)', () {
    testWidgets('known + unknown keys resolve without leaking raw key', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        Builder(builder: (BuildContext context) {
          final AppLocalizations l10n = AppLocalizations.of(context);
          // 已登记 key。
          expect(l10n.byMessageKey('auth.error.invalidCredentials'),
              equals(l10n.auth_error_invalidCredentials));
          // 未登记 key → 回退通用错误,绝不暴露裸 key。
          expect(l10n.byMessageKey('totally.unknown.key'),
              equals(l10n.common_error_generic));
          return const SizedBox.shrink();
        }),
        locale: const Locale('en'),
      ));
    });
  });

  group('Progress ring RTL (UI §3.7/§8.2)', () {
    testWidgets('renders in both LTR and RTL without crashing', (WidgetTester tester) async {
      for (final Locale locale in const <Locale>[Locale('en'), Locale('ar')]) {
        await tester.pumpWidget(_wrap(
          const ProgressRing(
            consumed: 1230,
            goal: 2000,
            centerTop: '1230',
            centerBottom: '/ 2000 kcal',
          ),
          locale: locale,
        ));
        await tester.pump(const Duration(milliseconds: 900));
        expect(find.byType(ProgressRing), findsOneWidget);
      }
    });
  });
}
