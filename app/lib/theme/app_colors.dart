import 'package:flutter/material.dart';

/// 设计令牌 · 配色(UI-DESIGN.md §2.1/§2.2/§2.3 + §9.1)。
///
/// 唯一颜色来源:任何页面禁止直接写 Color(0xFF...),一律引用此处或 [ColorScheme]。
/// 仅浅色模式(PRD C8 不做深色),故不提供 dark 调色板。
///
/// 风格 v2 ·「极简专业 · 数据导向」:近黑白中性盘 + 单一克制墨绿强调色。
/// 背景近白、文字近黑、灰阶完整;强调色仅用于关键操作/进度,不大面积铺。
/// 常量名保持不变(只改值),前端无缝套用。
abstract final class AppColors {
  AppColors._();

  // —— Material 3 ColorScheme 角色色(Light)——
  // 单一强调色:克制的深墨绿(更中性、更专业,不刺眼)。仅用于关键操作/进度。
  static const Color primary = Color(0xFF1F6E4E); // 品牌强调色(克制墨绿)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE3EFE9); // 极淡绿(选中底/轻强调)
  static const Color onPrimaryContainer = Color(0xFF103A29);

  // 次强调收为近黑中性,避免第二个彩色抢戏(数据导向只留一个彩色锚点)。
  static const Color secondary = Color(0xFF3A3F46); // 近黑灰(次按钮/辅助标识)
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEDEFF2); // 中性浅灰容器
  static const Color onSecondaryContainer = Color(0xFF1F2329);

  // tertiary 收为克制琥珀(仅极少量数据点缀,如超目标提示),不再做大面积暖橙。
  static const Color tertiary = Color(0xFFB4671F); // 克制琥珀(数据点缀)
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFF4E6D6);
  static const Color onTertiaryContainer = Color(0xFF3D2408);

  static const Color error = Color(0xFFB3261E); // 错误态 / 注销危险按钮(克制红)
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  static const Color surface = Color(0xFFF7F8FA); // 页面背景(极浅中性灰白)
  static const Color onSurface = Color(0xFF16181D); // 主文字(近黑)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // 卡片底(纯白)
  static const Color surfaceContainerLow = Color(0xFFF2F3F6);
  static const Color surfaceContainer = Color(0xFFEDEFF2); // 输入框/骨架底
  static const Color surfaceContainerHigh = Color(0xFFE6E8ED);
  static const Color onSurfaceVariant = Color(0xFF6B7280); // 次要文字/占位(中性灰)

  static const Color outline = Color(0xFFD2D5DB); // 边框/分隔(细边)
  static const Color outlineVariant = Color(0xFFE6E8ED); // 极浅分隔线

  static const Color inverseSurface = Color(0xFF22262C); // Snackbar 底(近黑)
  static const Color onInverseSurface = Color(0xFFF2F3F6);

  static const Color scrim = Color(0xFF000000); // @40% 弹窗遮罩

  // —— 中性灰阶(§2.2,完整 7 级)——
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF7F8FA);
  static const Color neutral100 = Color(0xFFEDEFF2);
  static const Color neutral300 = Color(0xFFD2D5DB);
  static const Color neutral500 = Color(0xFF9CA3AF); // 弱文字/禁用图标
  static const Color neutral700 = Color(0xFF6B7280); // 次要文字
  static const Color neutral900 = Color(0xFF16181D); // 主文字

  // —— 语义 / 宏量色(数据可视化,§2.3)——
  // 克制但可区分;同饱和度档,放一起不刺眼(数据导向)。
  static const Color macroProtein = Color(0xFF3B6EA5); // 蛋白(钢蓝)
  static const Color macroCarbs = Color(0xFFB4671F); // 碳水(克制琥珀 = tertiary)
  static const Color macroFat = Color(0xFF8A7A2E); // 脂肪(克制橄榄黄)

  static const Color success = primary;
  static const Color warning = Color(0xFF9A6A12); // 低置信度标记(克制琥珀)

  static const Color progressRingTrack = Color(0xFFE6E8ED); // 进度环底环(浅中性)
  static const Color progressRingOver = Color(0xFFB4671F); // 超目标转克制琥珀(不报警红)

  // —— 背景:极简专业版去渐变/色斑,改干净纯色(下列令牌保名仅作兼容)——
  // 极简风不要柔光色斑;[AppGradientBackground] 改为铺纯 surface 色。
  // 渐变两端取同色(= surface),即使被引用也呈现纯净平面;色斑令牌设为全透明。
  static const Color gradientTop = surface; // #F7F8FA
  static const Color gradientBottom = surface; // = surface,无渐变

  // 色斑保名但全透明(0 alpha):极简风默认 showBlobs=false,此处亦不产生任何可见斑。
  static const Color blobPrimary = Color(0x00000000);
  static const Color blobPrimaryTransparent = Color(0x00000000);
  static const Color blobTertiary = Color(0x00000000);
  static const Color blobTertiaryTransparent = Color(0x00000000);
}
