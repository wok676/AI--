/// 测试定位标识集中注册表(QA 自动化基座)。
///
/// 约定(工作流):**关键交互/状态控件必须挂稳定、集中管理的 [ValueKey]**,
/// 供 QA 的 `integration_test` 用 `find.byKey(ValueKey(TestKeys.xxx))` 直接定位,
/// 取代 adb 猜坐标的脆弱手点测试。
///
/// 规范:
/// - 所有 key 字符串在此处**唯一定义**,业务代码只引用常量,不散落字面量;
/// - 命名语义化、稳定:`<域>_<控件>`(下划线分隔),改 UI 不轻易改 key;
/// - **绝不含任何敏感信息**(无密钥/口令/PII),仅作为测试锚点;
/// - 值与常量名一致,便于在 Widget Inspector / 抓取树中肉眼对照。
abstract final class TestKeys {
  TestKeys._();

  // ───────────────────────── 认证(features/auth) ─────────────────────────
  /// 邮箱输入框。
  static const String loginEmailField = 'auth_email_field';

  /// 密码输入框。
  static const String loginPasswordField = 'auth_password_field';

  /// 密码可见性切换按钮。
  static const String loginPasswordToggle = 'auth_password_toggle';

  /// 知情同意勾选行(整行可点;仅注册态显示)。
  static const String consentCheckbox = 'auth_consent_checkbox';

  /// 登录/注册模式切换按钮。
  static const String authModeSwitch = 'auth_mode_switch';

  /// 主提交按钮(登录或注册,文案随模式变化)。
  static const String loginSubmitBtn = 'auth_submit_btn';

  /// 忘记密码入口。
  static const String forgotPasswordBtn = 'auth_forgot_password_btn';

  /// Sign in with Apple 按钮(仅 iOS 渲染)。
  static const String appleSignInBtn = 'auth_apple_signin_btn';

  // ───────────────── 底部导航 + 今日(features/shell, features/home) ─────────────────
  /// 底部导航容器。
  static const String navBar = 'shell_nav_bar';

  /// 今日 Tab。
  static const String tabToday = 'shell_tab_today';

  /// 历史 Tab。
  static const String tabHistory = 'shell_tab_history';

  /// 资料 Tab。
  static const String tabProfile = 'shell_tab_profile';

  /// 今日页根滚动容器(进入主页的断言锚点)。
  static const String todayScreen = 'today_screen';

  /// 记录一餐 FAB。
  static const String recordMealBtn = 'today_record_meal_fab';

  /// 进度环(已摄入/目标,供断言)。
  static const String todayProgressRing = 'today_progress_ring';

  /// 今日空态(当日无记录)的中部 CTA。
  static const String todayEmptyCta = 'today_empty_cta';

  // ───────────────────────── 录入流程(features/capture) ─────────────────────────
  /// 录入方式选择 BottomSheet。
  static const String captureMethodSheet = 'capture_method_sheet';

  /// 拍照入口。
  static const String captureOptionPhoto = 'capture_option_photo';

  /// 相册入口。
  static const String captureOptionGallery = 'capture_option_gallery';

  /// 文字录入入口。
  static const String captureOptionText = 'capture_option_text';

  /// 文字录入多行输入框。
  static const String captureTextField = 'capture_text_field';

  /// 文字录入「识别」提交按钮。
  static const String captureRecognizeBtn = 'capture_recognize_btn';

  /// 识别结果确认页保存按钮。
  static const String recognitionSaveBtn = 'recognition_save_btn';

  /// 识别确认页「手动添加一项」。
  static const String recognitionAddManualBtn = 'recognition_add_manual_btn';

  // ───────────────────────── 目标(features/goal) ─────────────────────────
  /// 目标 kcal 输入框。
  static const String goalKcalField = 'goal_kcal_field';

  /// 「帮我估算」折叠区入口。
  static const String goalEstimateToggle = 'goal_estimate_toggle';

  /// 估算计算按钮。
  static const String goalEstimateBtn = 'goal_estimate_btn';

  /// 把估算结果应用到 kcal 的按钮。
  static const String goalEstimateApplyBtn = 'goal_estimate_apply_btn';

  /// 目标保存按钮。
  static const String goalSaveBtn = 'goal_save_btn';

  /// 免责声明区。
  static const String goalDisclaimer = 'goal_disclaimer';

  // ───────────────────────── 历史(features/history) ─────────────────────────
  /// 日/趋势切换分段控件。
  static const String historyTabSwitch = 'history_tab_switch';

  /// 上一天按钮。
  static const String historyPrevDay = 'history_prev_day';

  /// 下一天按钮。
  static const String historyNextDay = 'history_next_day';

  /// 趋势柱状图。
  static const String historyTrendChart = 'history_trend_chart';

  // ───────────── 资料 + 注销(features/profile, features/profile/account_delete_dialog) ─────────────
  /// 资料页根滚动容器。
  static const String profileScreen = 'profile_screen';

  /// 语言选择入口。
  static const String languageEntry = 'profile_language_entry';

  /// 退出登录按钮。
  static const String logoutBtn = 'profile_logout_btn';

  /// 退出登录确认弹窗的确认按钮。
  static const String logoutConfirmBtn = 'logout_confirm_btn';

  /// 退出登录确认弹窗的取消按钮。
  static const String logoutCancelBtn = 'logout_cancel_btn';

  /// 注销账号入口。
  static const String deleteAccountBtn = 'profile_delete_account_btn';

  /// 注销二次确认弹窗的验密输入框。
  static const String deleteConfirmPasswordField = 'delete_confirm_password_field';

  /// 注销二次确认弹窗的确认按钮(error 危险色)。
  static const String deleteConfirmBtn = 'delete_confirm_btn';

  /// 注销二次确认弹窗的取消按钮。
  static const String deleteCancelBtn = 'delete_cancel_btn';

  // ───────────────────────── 语言选择(features/profile/language_picker) ─────────────────────────
  /// 「跟随系统」选项。
  static const String languageOptionSystem = 'language_option_system';

  /// 单个语言项 key 工厂:按语言码生成稳定 key(如 zh / en / ar)。
  static String languageOption(String code) => 'language_option_$code';

  // ───────────────────────── 三态 / 反馈(common/widgets) ─────────────────────────
  /// 加载态容器(骨架/进度)。
  static const String stateLoading = 'state_loading';

  /// 空态容器。
  static const String stateEmpty = 'state_empty';

  /// 空态主操作按钮。
  static const String stateEmptyAction = 'state_empty_action';

  /// 错误态容器。
  static const String stateError = 'state_error';

  /// 错误态重试按钮。
  static const String stateErrorRetry = 'state_error_retry';
}
