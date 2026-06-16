import 'package:flutter/material.dart';

/// 设计令牌 · 配色(UI-DESIGN.md §2.1/§2.2/§2.3 + §9.1)。
///
/// 唯一颜色来源:任何页面禁止直接写 Color(0xFF...),一律引用此处或 [ColorScheme]。
/// 仅浅色模式(PRD C8 不做深色),故不提供 dark 调色板。
abstract final class AppColors {
  AppColors._();

  // —— Material 3 ColorScheme 角色色(Light)——
  static const Color primary = Color(0xFF2E7D5B); // 品牌主色(清新墨绿)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFB6E5CE);
  static const Color onPrimaryContainer = Color(0xFF0A3D2A);

  static const Color secondary = Color(0xFF4E8C7A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCDE9DF);
  static const Color onSecondaryContainer = Color(0xFF10362B);

  static const Color tertiary = Color(0xFFE07A3F); // 暖橙食物点缀
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFBDEC9);
  static const Color onTertiaryContainer = Color(0xFF4A2410);

  static const Color error = Color(0xFFBA1A1A); // 错误态 / 注销危险按钮
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color surface = Color(0xFFFCFDFB); // 页面背景(极浅暖白)
  static const Color onSurface = Color(0xFF1A1C1A);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // 卡片底
  static const Color surfaceContainerLow = Color(0xFFF4F7F2);
  static const Color surfaceContainer = Color(0xFFEEF2EC); // 输入框/骨架底
  static const Color surfaceContainerHigh = Color(0xFFE8EDE6);
  static const Color onSurfaceVariant = Color(0xFF414941); // 次要文字/占位

  static const Color outline = Color(0xFF717971);
  static const Color outlineVariant = Color(0xFFC1C9BF);

  static const Color inverseSurface = Color(0xFF2F312E); // Snackbar 底
  static const Color onInverseSurface = Color(0xFFF0F1EC);

  static const Color scrim = Color(0xFF000000); // @40% 弹窗遮罩

  // —— 中性灰阶(§2.2)——
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF4F7F2);
  static const Color neutral100 = Color(0xFFEEF2EC);
  static const Color neutral300 = Color(0xFFC1C9BF);
  static const Color neutral500 = Color(0xFF717971);
  static const Color neutral700 = Color(0xFF414941);
  static const Color neutral900 = Color(0xFF1A1C1A);

  // —— 语义 / 宏量色(数据可视化,§2.3)——
  static const Color macroProtein = Color(0xFF3D7DCA); // 蛋白(蓝)
  static const Color macroCarbs = Color(0xFFE07A3F); // 碳水(暖橙 = tertiary)
  static const Color macroFat = Color(0xFFE0B73F); // 脂肪(琥珀黄)

  static const Color success = primary;
  static const Color warning = Color(0xFFC98A14); // 低置信度标记

  static const Color progressRingTrack = Color(0xFFE8EDE6);
  static const Color progressRingOver = Color(0xFFE07A3F); // 超目标转暖橙(不报警红)
}
