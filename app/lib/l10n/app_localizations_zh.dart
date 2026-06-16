// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '热量记录';

  @override
  String get brandTagline => '拍下这餐,了解热量';

  @override
  String get common_continue => '继续';

  @override
  String get common_save => '保存';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '确认';

  @override
  String get common_delete => '删除';

  @override
  String get common_edit => '编辑';

  @override
  String get common_retry => '重试';

  @override
  String get common_loading => '加载中…';

  @override
  String get common_empty => '暂无数据';

  @override
  String get common_error_generic => '出了点问题,请稍后再试';

  @override
  String get common_error_network => '网络连接异常,请检查网络';

  @override
  String get common_error_timeout => '请求超时,请重试';

  @override
  String get errors_unauthorized => '登录已过期,请重新登录';

  @override
  String get errors_forbidden => '你没有权限执行此操作';

  @override
  String get errors_notFound => '资源不存在';

  @override
  String get auth_signup_title => '注册';

  @override
  String get auth_login_title => '登录';

  @override
  String get auth_field_email => '邮箱';

  @override
  String get auth_field_password => '密码';

  @override
  String get auth_password_weak => '密码强度较弱,建议包含字母与数字';

  @override
  String get auth_email_invalid => '邮箱格式不正确';

  @override
  String get auth_consent_label => '我已阅读并同意《用户协议》和《隐私政策》';

  @override
  String get auth_consent_terms => '用户协议';

  @override
  String get auth_consent_privacy => '隐私政策';

  @override
  String get auth_consent_required => '请先阅读并同意协议与隐私政策';

  @override
  String get auth_apple_signin => '通过 Apple 登录';

  @override
  String get auth_google_signin => '通过 Google 登录';

  @override
  String get auth_logout => '退出登录';

  @override
  String get auth_forgotPassword => '忘记密码';

  @override
  String get auth_error_invalidCredentials => '邮箱或密码错误';

  @override
  String get capture_method_photo => '拍照';

  @override
  String get capture_method_gallery => '相册';

  @override
  String get capture_method_text => '文字描述';

  @override
  String get capture_text_placeholder => '例:一碗牛肉面 + 一个煎蛋';

  @override
  String get capture_cta_recognize => '识别';

  @override
  String get recognize_loading => 'AI 正在识别你的食物…';

  @override
  String get recognize_result_title => '识别结果';

  @override
  String get recognize_item_calories => '热量';

  @override
  String get recognize_item_protein => '蛋白质';

  @override
  String get recognize_item_carbs => '碳水';

  @override
  String get recognize_item_fat => '脂肪';

  @override
  String get recognize_item_serving => '份量';

  @override
  String get recognize_item_addManual => '手动添加一项';

  @override
  String get recognize_lowConfidence => '此项识别置信度较低,请核对';

  @override
  String get recognize_disclaimer => '热量及营养数据由 AI 估算,可能存在误差,仅供参考,不构成医疗或健康建议';

  @override
  String get recognize_error_failed => '没能识别这张图片,试试换一张或手动添加';

  @override
  String get recognize_limit_reached => '今日识别次数已达上限,请明天再试';

  @override
  String get meal_breakfast => '早餐';

  @override
  String get meal_lunch => '午餐';

  @override
  String get meal_dinner => '晚餐';

  @override
  String get meal_snack => '加餐';

  @override
  String get home_today => '今日';

  @override
  String home_streak(int count) {
    return '已连续记录 $count 天';
  }

  @override
  String get home_empty_cta => '拍下你的第一餐';

  @override
  String get home_fab_addMeal => '记录一餐';

  @override
  String get summary_consumed => '已摄入';

  @override
  String get summary_goal => '目标';

  @override
  String summary_remaining(int kcal) {
    return '还可摄入 $kcal kcal';
  }

  @override
  String get history_tab_day => '日';

  @override
  String get history_tab_trend => '趋势';

  @override
  String get goal_title => '每日热量目标';

  @override
  String get goal_estimate_cta => '帮我估算';

  @override
  String get goal_field_height => '身高';

  @override
  String get goal_field_weight => '体重';

  @override
  String get goal_field_activity => '活动量';

  @override
  String get goal_disclaimer => '估算值仅供参考,可自行调整,非医疗建议';

  @override
  String get perm_camera_title => '需要使用相机';

  @override
  String get perm_camera_body => '用于拍摄你的食物以进行 AI 识别。仅在你主动拍照时使用。';

  @override
  String get perm_photos_title => '需要访问相册';

  @override
  String get perm_photos_body => '用于选择食物图片进行识别。仅读取你选择的照片。';

  @override
  String get perm_notify_title => '开启提醒';

  @override
  String get perm_notify_body => '帮你养成记录习惯,可随时在设置中关闭。';

  @override
  String get perm_allow => '允许';

  @override
  String get perm_notNow => '暂不';

  @override
  String get perm_openSettings => '去设置开启';

  @override
  String get settings_title => '设置';

  @override
  String get settings_language => '语言';

  @override
  String get settings_units => '单位';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_profile => '个人资料';

  @override
  String get settings_terms => '用户协议';

  @override
  String get settings_privacy => '隐私政策';

  @override
  String get settings_about => '关于';

  @override
  String get settings_language_title => '选择语言';

  @override
  String get settings_language_systemDefault => '跟随系统';

  @override
  String get account_delete_entry => '注销账号';

  @override
  String get account_delete_title => '确认注销账号?';

  @override
  String get account_delete_warning =>
      '注销后,你的饮食记录、照片、个人资料与目标将被彻底、不可逆地删除,且无法恢复。';

  @override
  String get account_delete_confirmHint => '请输入密码以确认注销';

  @override
  String get account_delete_confirmBtn => '确认注销';

  @override
  String get account_delete_success => '你的账号与数据已彻底删除';

  @override
  String get account_delete_web => '你也可以在网页端注销账号';

  @override
  String get privacy_photo_retention =>
      '你的食物照片仅用于即时 AI 识别,识别后不会长期保存原图,我们仅保存识别出的结果数据。';

  @override
  String get auth_signup_switchToLogin => '已有账号?去登录';

  @override
  String get auth_login_switchToSignup => '还没有账号?去注册';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => '或';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => '千卡';

  @override
  String get summary_goalNotSet => '尚未设置目标';

  @override
  String get today_mealNotLogged => '未记录';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
      one: '1 项',
      zero: '无条目',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => '记录一餐';

  @override
  String get capture_text_title => '描述你的食物';

  @override
  String get capture_camera_unavailable => '此设备无法使用相机,请改用相册或文字录入。';

  @override
  String get capture_gallery_unavailable => '未选择任何照片。';

  @override
  String get recognize_item_serving_unit_serving => '份';

  @override
  String get recognize_item_serving_unit_piece => '个';

  @override
  String get recognize_item_serving_unit_gram => '克';

  @override
  String get recognize_editItem_title => '编辑食物项';

  @override
  String get recognize_field_name => '食物名称';

  @override
  String get recognize_field_quantity => '数量';

  @override
  String get recognize_field_unit => '单位';

  @override
  String get recognize_mealType_label => '餐次';

  @override
  String get recognize_save_success => '已保存这一餐';

  @override
  String get recognize_emptyItems => '保存前请至少保留一项';

  @override
  String get history_prevDay => '前一天';

  @override
  String get history_nextDay => '后一天';

  @override
  String get history_trend_title => '近 7 天';

  @override
  String get history_trend_caloriesLegend => '热量';

  @override
  String get history_trend_goalLegend => '目标';

  @override
  String get meal_delete_confirm => '删除这一餐?此操作不可撤销。';

  @override
  String get meal_delete_success => '已删除这一餐';

  @override
  String get goal_field_kcal => '每日目标(千卡)';

  @override
  String get goal_sex_label => '性别';

  @override
  String get goal_sex_male => '男';

  @override
  String get goal_sex_female => '女';

  @override
  String get goal_field_age => '年龄';

  @override
  String get goal_activity_sedentary => '久坐';

  @override
  String get goal_activity_light => '轻度';

  @override
  String get goal_activity_moderate => '中度';

  @override
  String get goal_activity_active => '活跃';

  @override
  String get goal_activity_veryActive => '非常活跃';

  @override
  String get goal_type_label => '目标';

  @override
  String get goal_type_lose => '减重';

  @override
  String get goal_type_maintain => '维持';

  @override
  String get goal_type_gain => '增重';

  @override
  String goal_estimate_result(int kcal) {
    return '建议参考值:$kcal 千卡';
  }

  @override
  String get goal_estimate_apply => '采用此值';

  @override
  String get goal_save_success => '目标已保存';

  @override
  String get settings_units_energy => '能量';

  @override
  String get settings_units_mass => '质量';

  @override
  String get settings_units_kcal => '千卡';

  @override
  String get settings_units_kj => '千焦';

  @override
  String get settings_units_g => '克';

  @override
  String get settings_units_oz => '盎司';

  @override
  String get settings_account_section => '账号';

  @override
  String get settings_dangerZone => '危险操作';

  @override
  String get account_delete_cancel => '取消';

  @override
  String get logout_confirm => '确认退出登录?';
}
