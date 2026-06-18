import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'l10n/locale_controller.dart';
import 'l10n/supported_locales.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// 应用根。监听语言偏好 → 实时切换 locale / 主题字体 / LTR-RTL(无需重启,PRD §4.8.3)。
class CalorieApp extends ConsumerWidget {
  const CalorieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LocaleState localeState = ref.watch(localeControllerProvider);
    final Locale locale = localeState.effective;
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,

      // 仅浅色模式(PRD C8):light/dark 同源,锁 light,避免系统深色反色。
      theme: AppTheme.light(locale),
      darkTheme: AppTheme.light(locale),
      themeMode: ThemeMode.light,

      // i18n:注册 12 locale;ar/ur 由 flutter_localizations 自动按 textDirection 镜像布局。
      locale: locale,
      supportedLocales: SupportedLocales.all,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 系统 locale 落在 12 种之外时回退 en(PRD §4.8.3)。
      localeResolutionCallback: (Locale? device, Iterable<Locale> supported) =>
          SupportedLocales.resolve(device),

      routerConfig: router,
    );
  }
}
