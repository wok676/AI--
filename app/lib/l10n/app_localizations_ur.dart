// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'کیلوری ٹریکر';

  @override
  String get brandTagline => 'اپنے کھانے کی تصویر لیں۔ کیلوریز جانیں۔';

  @override
  String get common_continue => 'جاری رکھیں';

  @override
  String get common_save => 'محفوظ کریں';

  @override
  String get common_cancel => 'منسوخ کریں';

  @override
  String get common_confirm => 'تصدیق کریں';

  @override
  String get common_delete => 'حذف کریں';

  @override
  String get common_edit => 'ترمیم کریں';

  @override
  String get common_retry => 'دوبارہ کوشش کریں';

  @override
  String get common_loading => 'لوڈ ہو رہا ہے…';

  @override
  String get common_empty => 'ابھی یہاں کچھ نہیں ہے';

  @override
  String get common_error_generic =>
      'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get common_error_network => 'نیٹ ورک کی خرابی۔ اپنا کنکشن چیک کریں۔';

  @override
  String get common_error_timeout =>
      'درخواست کا وقت ختم ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get errors_unauthorized =>
      'سیشن ختم ہو گیا، براہ کرم دوبارہ لاگ ان کریں';

  @override
  String get errors_forbidden => 'آپ کو یہ عمل انجام دینے کی اجازت نہیں ہے';

  @override
  String get errors_notFound => 'وسیلہ نہیں ملا';

  @override
  String get auth_signup_title => 'سائن اپ';

  @override
  String get auth_login_title => 'لاگ ان';

  @override
  String get auth_field_email => 'ای میل';

  @override
  String get auth_field_password => 'پاس ورڈ';

  @override
  String get auth_password_weak =>
      'کمزور پاس ورڈ۔ حروف اور اعداد استعمال کریں۔';

  @override
  String get auth_email_invalid => 'غلط ای میل ایڈریس';

  @override
  String get auth_consent_label =>
      'میں نے سروس کی شرائط اور پرائیویسی پالیسی پڑھ لی ہیں اور متفق ہوں';

  @override
  String get auth_consent_terms => 'سروس کی شرائط';

  @override
  String get auth_consent_privacy => 'پرائیویسی پالیسی';

  @override
  String get auth_consent_required =>
      'براہ کرم پہلے شرائط اور پرائیویسی پالیسی پڑھ کر قبول کریں';

  @override
  String get auth_apple_signin => 'Apple سے سائن ان کریں';

  @override
  String get auth_google_signin => 'Google سے سائن ان کریں';

  @override
  String get auth_logout => 'لاگ آؤٹ';

  @override
  String get auth_forgotPassword => 'پاس ورڈ بھول گئے';

  @override
  String get auth_error_invalidCredentials => 'ای میل یا پاس ورڈ غلط ہے';

  @override
  String get capture_method_photo => 'تصویر لیں';

  @override
  String get capture_method_gallery => 'گیلری سے منتخب کریں';

  @override
  String get capture_method_text => 'متن میں بیان کریں';

  @override
  String get capture_text_placeholder =>
      'مثلاً: ایک پیالہ بیف نوڈلز + ایک فرائی انڈا';

  @override
  String get capture_cta_recognize => 'تجزیہ کریں';

  @override
  String get recognize_loading => 'آپ کے کھانے کا تجزیہ ہو رہا ہے…';

  @override
  String get recognize_result_title => 'نتائج';

  @override
  String get recognize_item_calories => 'کیلوریز';

  @override
  String get recognize_item_protein => 'پروٹین';

  @override
  String get recognize_item_carbs => 'کاربوہائیڈریٹس';

  @override
  String get recognize_item_fat => 'چکنائی';

  @override
  String get recognize_item_serving => 'سرونگ';

  @override
  String get recognize_item_addManual => 'آئٹم دستی طور پر شامل کریں';

  @override
  String get recognize_lowConfidence => 'کم اعتماد — براہ کرم دوبارہ جانچیں';

  @override
  String get recognize_disclaimer =>
      'کیلوریز اور غذائیت کے اعداد AI کے تخمینے ہیں اور غلط ہو سکتے ہیں۔ صرف حوالے کے لیے؛ یہ طبی یا صحت کا مشورہ نہیں ہے۔';

  @override
  String get recognize_error_failed =>
      'اس تصویر کو پہچانا نہیں جا سکا۔ دوسری تصویر آزمائیں یا دستی طور پر شامل کریں۔';

  @override
  String get recognize_limit_reached =>
      'آج کی شناخت کی حد پوری ہو گئی۔ کل دوبارہ کوشش کریں۔';

  @override
  String get meal_breakfast => 'ناشتہ';

  @override
  String get meal_lunch => 'دوپہر کا کھانا';

  @override
  String get meal_dinner => 'رات کا کھانا';

  @override
  String get meal_snack => 'ہلکا کھانا';

  @override
  String get home_today => 'آج';

  @override
  String home_streak(int count) {
    return '$count دن کا تسلسل';
  }

  @override
  String get home_empty_cta => 'اپنا پہلا کھانا ریکارڈ کریں';

  @override
  String get home_fab_addMeal => 'کھانا ریکارڈ کریں';

  @override
  String get home_greeting_morning => 'صبح بخیر 👋';

  @override
  String get home_greeting_afternoon => 'السلام علیکم 👋';

  @override
  String get home_greeting_evening => 'شب بخیر 👋';

  @override
  String get summary_consumed => 'استعمال شدہ';

  @override
  String get summary_goal => 'ہدف';

  @override
  String summary_remaining(int kcal) {
    return '$kcal kcal باقی';
  }

  @override
  String get history_title => 'تاریخچہ';

  @override
  String get history_tab_day => 'دن';

  @override
  String get history_tab_trend => 'رجحان';

  @override
  String get goal_title => 'روزانہ کیلوری ہدف';

  @override
  String get goal_estimate_cta => 'میرے لیے اندازہ لگائیں';

  @override
  String get goal_field_height => 'قد';

  @override
  String get goal_field_weight => 'وزن';

  @override
  String get goal_field_activity => 'سرگرمی کی سطح';

  @override
  String get goal_disclaimer =>
      'اندازہ صرف حوالے کے لیے ہے، قابلِ ایڈجسٹمنٹ ہے اور طبی مشورہ نہیں ہے۔';

  @override
  String get perm_camera_title => 'کیمرہ تک رسائی';

  @override
  String get perm_camera_body =>
      'AI تجزیے کے لیے آپ کے کھانے کی تصاویر لینے کے لیے۔ صرف تصویر لیتے وقت استعمال ہوتا ہے۔';

  @override
  String get perm_photos_title => 'تصاویر تک رسائی';

  @override
  String get perm_photos_body =>
      'تجزیے کے لیے کھانے کی تصویر منتخب کرنے کے لیے۔ صرف آپ کی منتخب کردہ تصویر پڑھی جاتی ہے۔';

  @override
  String get perm_notify_title => 'یاد دہانیاں آن کریں';

  @override
  String get perm_notify_body =>
      'ریکارڈ کرنے کی عادت بنانے میں مدد دیتا ہے۔ آپ اسے کسی بھی وقت بند کر سکتے ہیں۔';

  @override
  String get perm_allow => 'اجازت دیں';

  @override
  String get perm_notNow => 'ابھی نہیں';

  @override
  String get perm_openSettings => 'ترتیبات کھولیں';

  @override
  String get settings_title => 'ترتیبات';

  @override
  String get settings_language => 'زبان';

  @override
  String get settings_units => 'اکائیاں';

  @override
  String get settings_notifications => 'اطلاعات';

  @override
  String get settings_profile => 'پروفائل';

  @override
  String get settings_terms => 'سروس کی شرائط';

  @override
  String get settings_privacy => 'پرائیویسی پالیسی';

  @override
  String get settings_about => 'بارے میں';

  @override
  String get settings_language_title => 'زبان منتخب کریں';

  @override
  String get settings_language_systemDefault => 'سسٹم کے مطابق';

  @override
  String get account_delete_entry => 'اکاؤنٹ حذف کریں';

  @override
  String get account_delete_title => 'اپنا اکاؤنٹ حذف کریں؟';

  @override
  String get account_delete_warning =>
      'حذف کرنے کے بعد، آپ کے کھانے کے ریکارڈ، تصاویر، پروفائل اور اہداف مستقل اور ناقابلِ واپسی طور پر مٹا دیے جائیں گے اور بحال نہیں ہو سکتے۔';

  @override
  String get account_delete_confirmHint => 'تصدیق کے لیے اپنا پاس ورڈ درج کریں';

  @override
  String get account_delete_confirmBtn => 'اکاؤنٹ حذف کریں';

  @override
  String get account_delete_success =>
      'آپ کا اکاؤنٹ اور ڈیٹا مستقل طور پر حذف کر دیا گیا ہے';

  @override
  String get account_delete_web => 'آپ ویب پر بھی اپنا اکاؤنٹ حذف کر سکتے ہیں';

  @override
  String get privacy_photo_retention =>
      'آپ کے کھانے کی تصاویر صرف فوری AI تجزیے کے لیے استعمال ہوتی ہیں۔ اصل تصاویر طویل عرصے تک محفوظ نہیں رکھی جاتیں؛ ہم صرف شناخت شدہ نتیجے کا ڈیٹا رکھتے ہیں۔';

  @override
  String get auth_signup_switchToLogin => 'پہلے سے اکاؤنٹ ہے؟ لاگ ان کریں';

  @override
  String get auth_login_switchToSignup => 'ابھی تک اکاؤنٹ نہیں؟ سائن اپ کریں';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'یا';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'ابھی کوئی ہدف مقرر نہیں';

  @override
  String get today_mealNotLogged => 'ریکارڈ نہیں کیا گیا';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آئٹمز',
      one: '1 آئٹم',
      zero: 'کوئی آئٹم نہیں',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'کھانا ریکارڈ کریں';

  @override
  String get capture_text_title => 'اپنے کھانے کو بیان کریں';

  @override
  String get capture_camera_unavailable =>
      'اس ڈیوائس پر کیمرہ دستیاب نہیں ہے۔ اس کے بجائے گیلری یا متن آزمائیں۔';

  @override
  String get capture_gallery_unavailable => 'کوئی تصویر منتخب نہیں کی گئی۔';

  @override
  String get recognize_item_serving_unit_serving => 'سرونگ';

  @override
  String get recognize_item_serving_unit_piece => 'ٹکڑا';

  @override
  String get recognize_item_serving_unit_gram => 'گرام';

  @override
  String get recognize_editItem_title => 'آئٹم میں ترمیم کریں';

  @override
  String get recognize_field_name => 'کھانے کا نام';

  @override
  String get recognize_field_quantity => 'مقدار';

  @override
  String get recognize_field_unit => 'اکائی';

  @override
  String get recognize_mealType_label => 'کھانا';

  @override
  String get recognize_save_success => 'کھانا محفوظ ہو گیا';

  @override
  String get recognize_emptyItems =>
      'محفوظ کرنے سے پہلے کم از کم ایک آئٹم شامل کریں';

  @override
  String get history_prevDay => 'پچھلا دن';

  @override
  String get history_nextDay => 'اگلا دن';

  @override
  String get history_trend_title => 'گزشتہ 7 دن';

  @override
  String get history_trend_caloriesLegend => 'کیلوریز';

  @override
  String get history_trend_goalLegend => 'ہدف';

  @override
  String get meal_delete_confirm =>
      'اس کھانے کو حذف کریں؟ یہ واپس نہیں ہو سکتا۔';

  @override
  String get meal_delete_success => 'کھانا حذف ہو گیا';

  @override
  String get goal_field_kcal => 'روزانہ ہدف (kcal)';

  @override
  String get goal_sex_label => 'جنس';

  @override
  String get goal_sex_male => 'مرد';

  @override
  String get goal_sex_female => 'عورت';

  @override
  String get goal_field_age => 'عمر';

  @override
  String get goal_activity_sedentary => 'بیٹھے رہنا';

  @override
  String get goal_activity_light => 'ہلکی';

  @override
  String get goal_activity_moderate => 'درمیانی';

  @override
  String get goal_activity_active => 'متحرک';

  @override
  String get goal_activity_veryActive => 'بہت متحرک';

  @override
  String get goal_type_label => 'ہدف';

  @override
  String get goal_type_lose => 'وزن کم کرنا';

  @override
  String get goal_type_maintain => 'برقرار رکھنا';

  @override
  String get goal_type_gain => 'وزن بڑھانا';

  @override
  String goal_estimate_result(int kcal) {
    return 'تجویز کردہ: $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'یہ قدر استعمال کریں';

  @override
  String get goal_save_success => 'ہدف محفوظ ہو گیا';

  @override
  String get settings_units_energy => 'توانائی';

  @override
  String get settings_units_mass => 'کمیت';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'گرام';

  @override
  String get settings_units_oz => 'اونس';

  @override
  String get settings_account_section => 'اکاؤنٹ';

  @override
  String get settings_dangerZone => 'خطرناک حصہ';

  @override
  String get account_delete_cancel => 'منسوخ کریں';

  @override
  String get logout_confirm => 'اپنے اکاؤنٹ سے لاگ آؤٹ کریں؟';

  @override
  String get legal_draftNotice =>
      'Draft for in-app review. This is a placeholder version: the final legal text will be provided by Product/Operations, and an official public URL will be published after deployment.';

  @override
  String get legal_lastUpdated => 'Last updated: 2026-06-17 (draft)';

  @override
  String get legal_contact_h => 'Contact Us';

  @override
  String get legal_contact_b =>
      'Questions about these terms or your data? Contact us at support@example.com (placeholder; final contact details pending). We aim to respond within a reasonable time.';

  @override
  String get legal_terms_title => 'Terms of Service';

  @override
  String get legal_terms_s1_h => '1. Acceptance of Terms';

  @override
  String get legal_terms_s1_b =>
      'By creating an account or using Calorie Tracker (the \"App\"), you agree to these Terms of Service. If you do not agree, please do not use the App. You must be old enough to consent to data processing in your jurisdiction.';

  @override
  String get legal_terms_s2_h => '2. The Service';

  @override
  String get legal_terms_s2_b =>
      'The App lets you log meals via photo, gallery image, or text, and uses AI to estimate calories and macronutrients (protein, carbohydrates, fat). All AI estimates are approximations for general informational purposes only.';

  @override
  String get legal_terms_s3_h => '3. AI Estimate Disclaimer';

  @override
  String get legal_terms_s3_b =>
      'Calorie and nutrient figures are automatically estimated and may be inaccurate. They are NOT medical, dietary, or health advice and must not be used for diagnosis or treatment. Always verify important values and consult a qualified professional for medical or nutritional decisions. You remain in control of and responsible for the data you save.';

  @override
  String get legal_terms_s4_h => '4. Your Responsibilities';

  @override
  String get legal_terms_s4_b =>
      'You are responsible for keeping your credentials secure, for the accuracy of information you enter, and for using the App lawfully. Do not misuse the App, attempt unauthorized access, or upload unlawful content.';

  @override
  String get legal_terms_s5_h => '5. Account Deletion';

  @override
  String get legal_terms_s5_b =>
      'You may delete your account at any time from Settings. Deletion is irreversible and permanently removes your meal logs, goals, and profile from our active systems, subject to limited retention required by law. See the Privacy Policy for details.';

  @override
  String get legal_terms_s6_h => '6. Changes & Limitation of Liability';

  @override
  String get legal_terms_s6_b =>
      'We may update the App and these Terms; material changes will be communicated in-app. To the extent permitted by law, the App is provided \"as is\" without warranties, and we are not liable for decisions made based on AI estimates.';

  @override
  String get legal_privacy_title => 'Privacy Policy';

  @override
  String get legal_privacy_s1_h => '1. Data We Collect';

  @override
  String get legal_privacy_s1_b =>
      'We collect: account data (email, or Apple ID identifier if you use Sign in with Apple); content you create (meal entries, food names, portions, calorie/macro values, optional thumbnails); preferences (language, units, daily goal, notification setting); and limited technical data needed to operate the service.';

  @override
  String get legal_privacy_s2_h => '2. How We Use Your Data';

  @override
  String get legal_privacy_s2_b =>
      'We use your data to provide core features (logging meals, generating AI calorie/macro estimates, tracking history and goals), to authenticate you, to remember your preferences, and to secure and improve the service. We do not sell your personal data.';

  @override
  String get legal_privacy_s3_h => '3. Third-Party Services & Consent';

  @override
  String get legal_privacy_s3_b =>
      'Photo/text content may be processed by an AI recognition provider solely to return an estimate. Any optional analytics or push services remain disabled until you actively consent to this Policy; we do not initialize non-essential third-party SDKs before consent. Permissions (camera, photos, notifications) are requested only when you use the related feature.';

  @override
  String get legal_privacy_s4_h => '4. Storage & Security';

  @override
  String get legal_privacy_s4_b =>
      'Data is stored on secured servers and transmitted over encrypted (HTTPS) connections. Authentication tokens are kept in the device\'s secure storage. We apply access controls and retain data only as long as your account is active or as required by law.';

  @override
  String get legal_privacy_s5_h => '5. Account & Data Deletion';

  @override
  String get legal_privacy_s5_b =>
      'Deleting your account (Settings > Delete account, with confirmation) permanently and irreversibly removes your profile, meal logs, and goals from our active systems, and clears all credentials stored on your device. A web-based deletion channel is also available where required.';

  @override
  String get legal_privacy_s6_h => '6. Your Rights';

  @override
  String get legal_privacy_s6_b =>
      'Subject to your local laws, you may access, correct, export, or delete your data. To exercise these rights, use the in-app controls or contact us. We will respond consistent with applicable data-protection law.';
}
