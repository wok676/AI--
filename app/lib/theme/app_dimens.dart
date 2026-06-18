/// 设计令牌 · 间距 / 圆角 / 阴影 / 点按区(UI-DESIGN.md §2.5/§2.6/§2.7 + §9.2)。
///
/// 8pt 基准网格。任何页面禁止散落魔法数,一律引用此处。
/// 风格 v2 ·「极简专业」:圆角收小(卡片/按钮 10–12,非大药丸)、间距紧凑专业。
abstract final class AppSpacing {
  AppSpacing._();

  static const double xxs = 4; // 图标与文字贴合
  static const double xs = 8; // 紧凑内边距
  static const double sm = 12; // 卡片内元素间距 / 列表项垂直内边距
  static const double md = 16; // 默认页面水平边距 / 卡片内边距
  static const double lg = 24; // 区块间距
  static const double xl = 32; // 大区块 / 页眉下方
  static const double xxl = 48; // 空态插画上下留白
}

/// 圆角(§2.6)。极简专业:卡片 12、按钮 10、输入框 10;不用 999 大药丸。
abstract final class AppRadius {
  AppRadius._();

  static const double xs = 6; // 小 Chip / 标记 / 进度条端
  static const double sm = 10; // 输入框 / 按钮 / Snackbar
  static const double md = 12; // 卡片 / 列表卡
  static const double lg = 16; // Bottom Sheet 顶角 / 大弹窗
  // 保名兼容:极简风不再用胶囊全圆角;若被引用,退化为常规小圆角(12),
  // 避免出现大药丸。进度环端帽在绘制处单独用 StrokeCap.round,不依赖此值。
  static const double full = 12;
}

/// M3 tonal elevation 阶梯(§2.7)。极简专业:阴影极淡,以细边为主。
abstract final class AppElevation {
  AppElevation._();

  static const double level0 = 0; // 页面背景
  static const double level1 = 0; // 卡片 / 列表卡:扁平,用 1dp 细边代替阴影
  static const double level2 = 1; // FAB / 悬浮主按钮:极轻浮起
  static const double level3 = 3; // 弹窗 / Bottom Sheet
}

/// 点按目标与组件尺寸(§3 / §9.2)。
abstract final class AppSizes {
  AppSizes._();

  /// 最小点按区(Material 最小,满足 iOS 44pt;合规勾选/弹窗按钮强制)。
  static const double hitTarget = 48;

  static const double buttonHeightCta = 52; // 关键 CTA(收紧,扁平专业)
  static const double buttonHeight = 48; // 常规按钮
  static const double inputHeight = 52;
  static const double navBarHeight = 72; // 收紧的底部导航

  static const double progressRingDiameter = 200;
  static const double progressRingStroke = 12; // 收细环宽,数字为主、环为辅
  static const double macroBarHeight = 6;
}

/// 动效时长(§9.4)。
abstract final class AppMotion {
  AppMotion._();

  static const Duration progressRingIn = Duration(milliseconds: 800);
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration buttonPress = Duration(milliseconds: 120);
  static const Duration shimmer = Duration(milliseconds: 1200);
  static const Duration snackbar = Duration(milliseconds: 250);
  static const Duration localeReflow = Duration(milliseconds: 200);
}
