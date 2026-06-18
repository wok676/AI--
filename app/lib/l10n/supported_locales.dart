import 'package:flutter/material.dart';

/// v1 支持的 12 种语言(PRD §4.8.1)。
/// ar/ur 为 RTL;ja/ko 为 LTR(仅切日韩字体)。en 为 fallback。
abstract final class SupportedLocales {
  SupportedLocales._();

  /// 顺序对齐 UI §5.7 语言选择器列表。
  static const List<Locale> all = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('hi'),
    Locale('es'),
    Locale('fr'),
    Locale('ar'),
    Locale('bn'),
    Locale('pt'),
    Locale('ru'),
    Locale('ur'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// 回退语言(系统 locale 落在 12 种之外时,PRD §4.8.3)。
  static const Locale fallback = Locale('en');

  /// RTL 语言集合(整体镜像布局,PRD §4.8.2 / UI §8)。
  static const Set<String> rtlLanguageCodes = <String>{'ar', 'ur'};

  static bool isRtl(Locale locale) =>
      rtlLanguageCodes.contains(locale.languageCode);

  /// 各语言自显名(语言选择器展示,不走 i18n —— 语言名以本语言书写)。
  static const Map<String, String> nativeNames = <String, String>{
    'en': 'English',
    'zh': '中文',
    'hi': 'हिन्दी',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية',
    'bn': 'বাংলা',
    'pt': 'Português',
    'ru': 'Русский',
    'ur': 'اردو',
    'ja': '日本語',
    'ko': '한국어',
  };

  /// 把任意候选 locale 收敛到受支持集合;不支持则回退 en。
  static Locale resolve(Locale? candidate) {
    if (candidate == null) return fallback;
    for (final Locale l in all) {
      if (l.languageCode == candidate.languageCode) return l;
    }
    return fallback;
  }
}
