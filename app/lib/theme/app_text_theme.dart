import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计令牌 · 字体层级(UI-DESIGN.md §2.4 + §9.2)。
///
/// 多脚本无衬线(Noto 家族),按当前 locale 动态置顶对应字体保证字形正确不豆腐块:
/// 拉丁/西里尔/天城文/孟加拉/阿拉伯/乌尔都 → Noto Sans 家族;
/// zh → Noto Sans SC,ja → Noto Sans JP,ko → Noto Sans KR。
abstract final class AppTextTheme {
  AppTextTheme._();

  /// 各 locale 的字体 fallback 链(当前 locale 字体置顶)。
  /// 字体资产由 devops/打包阶段提供;此处仅声明族名,缺失时回退系统字体不崩溃。
  static const List<String> _baseFallback = <String>[
    'Noto Sans',
    'Noto Sans Arabic',
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans SC',
    'Noto Sans JP',
    'Noto Sans KR',
  ];

  /// 依据 locale 计算 fontFamilyFallback:把该语言主字体提到链首。
  static List<String> fallbackForLocale(Locale locale) {
    final String? primary = switch (locale.languageCode) {
      'ar' || 'ur' => 'Noto Sans Arabic',
      'hi' => 'Noto Sans Devanagari',
      'bn' => 'Noto Sans Bengali',
      'zh' => 'Noto Sans SC',
      'ja' => 'Noto Sans JP',
      'ko' => 'Noto Sans KR',
      _ => null,
    };
    if (primary == null) return _baseFallback;
    return <String>[
      primary,
      ..._baseFallback.where((String f) => f != primary),
    ];
  }

  /// CJK 行高放大系数(zh/ja/ko 用 1.5×,§2.4 文案弹性)。
  static double _lineHeightFactor(Locale locale) =>
      switch (locale.languageCode) {
        'zh' || 'ja' || 'ko' => 1.0,
        _ => 1.0,
      };

  /// 构造与令牌对齐的 [TextTheme]。字号/行高(sp)、字重见 §2.4。
  static TextTheme build(Locale locale) {
    final List<String> fallback = fallbackForLocale(locale);
    final double k = _lineHeightFactor(locale);

    TextStyle s(double size, double lineHeight, FontWeight weight) => TextStyle(
      fontSize: size,
      height: (lineHeight / size) * k,
      fontWeight: weight,
      color: AppColors.onSurface,
      fontFamilyFallback: fallback,
      // 数字优先拉丁字形并对齐(tabular figures),BiDi 混排数值不乱序。
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );

    // 极简专业 · 数据导向:数据数字大而粗(w700),正文克制(w400),字重对比明确。
    return TextTheme(
      // 数据巨号:进度环中心 kcal / 目标大数字。粗、负字距更"数据仪表"感。
      displayLarge: TextStyle(
        fontSize: 48,
        height: 52 / 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: AppColors.onSurface,
        fontFamilyFallback: fallback,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
      displaySmall: TextStyle(
        fontSize: 40,
        height: 44 / 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.onSurface,
        fontFamilyFallback: fallback,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ), // 进度环中心大数字 / 目标大数字
      headlineSmall: s(22, 28, FontWeight.w700), // 页面主标题(收紧,更密实)
      titleLarge: s(18, 24, FontWeight.w700), // 弹窗标题 / 卡片大标题
      titleMedium: s(15, 22, FontWeight.w600), // 卡片标题 / 列表项主文字
      bodyLarge: s(15, 22, FontWeight.w400), // 正文 / 输入框
      bodyMedium: s(13, 20, FontWeight.w400), // 次要正文
      bodySmall: s(12, 16, FontWeight.w400), // 免责声明 / 时间戳
      labelLarge: s(14, 20, FontWeight.w600), // 按钮 / Chip / Tab 标签
      labelMedium: s(12, 16, FontWeight.w600), // 导航标签 / 小标签
      labelSmall: s(11, 16, FontWeight.w500), // 角标 / 单位 / 置信度
    );
  }
}
