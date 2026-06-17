// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متتبّع السعرات';

  @override
  String get brandTagline => 'صوّر وجبتك. واعرف سعراتها الحرارية.';

  @override
  String get common_continue => 'متابعة';

  @override
  String get common_save => 'حفظ';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get common_confirm => 'تأكيد';

  @override
  String get common_delete => 'حذف';

  @override
  String get common_edit => 'تعديل';

  @override
  String get common_retry => 'إعادة المحاولة';

  @override
  String get common_loading => 'جارٍ التحميل…';

  @override
  String get common_empty => 'لا شيء هنا بعد';

  @override
  String get common_error_generic => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get common_error_network => 'خطأ في الشبكة. يرجى التحقق من اتصالك.';

  @override
  String get common_error_timeout =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get errors_unauthorized => 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';

  @override
  String get errors_forbidden => 'غير مسموح لك بتنفيذ هذا الإجراء';

  @override
  String get errors_notFound => 'المورد غير موجود';

  @override
  String get auth_signup_title => 'إنشاء حساب';

  @override
  String get auth_login_title => 'تسجيل الدخول';

  @override
  String get auth_field_email => 'البريد الإلكتروني';

  @override
  String get auth_field_password => 'كلمة المرور';

  @override
  String get auth_password_weak => 'كلمة مرور ضعيفة. استخدم أحرفًا وأرقامًا.';

  @override
  String get auth_email_invalid => 'عنوان بريد إلكتروني غير صالح';

  @override
  String get auth_consent_label =>
      'لقد قرأت وأوافق على شروط الخدمة وسياسة الخصوصية';

  @override
  String get auth_consent_terms => 'شروط الخدمة';

  @override
  String get auth_consent_privacy => 'سياسة الخصوصية';

  @override
  String get auth_consent_required =>
      'يرجى قراءة الشروط وسياسة الخصوصية والموافقة عليها أولاً';

  @override
  String get auth_apple_signin => 'تسجيل الدخول عبر Apple';

  @override
  String get auth_google_signin => 'تسجيل الدخول عبر Google';

  @override
  String get auth_logout => 'تسجيل الخروج';

  @override
  String get auth_forgotPassword => 'نسيت كلمة المرور';

  @override
  String get auth_error_invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get capture_method_photo => 'التقاط صورة';

  @override
  String get capture_method_gallery => 'اختيار من المعرض';

  @override
  String get capture_method_text => 'الوصف بالنص';

  @override
  String get capture_text_placeholder => 'مثال: طبق نودلز باللحم + بيضة مقلية';

  @override
  String get capture_cta_recognize => 'تحليل';

  @override
  String get recognize_loading => 'جارٍ تحليل طعامك…';

  @override
  String get recognize_result_title => 'النتائج';

  @override
  String get recognize_item_calories => 'السعرات الحرارية';

  @override
  String get recognize_item_protein => 'البروتين';

  @override
  String get recognize_item_carbs => 'الكربوهيدرات';

  @override
  String get recognize_item_fat => 'الدهون';

  @override
  String get recognize_item_serving => 'الحصة';

  @override
  String get recognize_item_addManual => 'إضافة عنصر يدويًا';

  @override
  String get recognize_lowConfidence => 'ثقة منخفضة — يرجى التحقق مجددًا';

  @override
  String get recognize_disclaimer =>
      'أرقام السعرات والتغذية تقديرات بالذكاء الاصطناعي وقد تكون غير دقيقة. للاسترشاد فقط؛ وليست نصيحة طبية أو صحية.';

  @override
  String get recognize_error_failed =>
      'تعذّر التعرّف على هذه الصورة. جرّب صورة أخرى أو أضِف يدويًا.';

  @override
  String get recognize_limit_reached =>
      'تم بلوغ الحد اليومي للتعرّف. حاول مرة أخرى غدًا.';

  @override
  String get meal_breakfast => 'الإفطار';

  @override
  String get meal_lunch => 'الغداء';

  @override
  String get meal_dinner => 'العشاء';

  @override
  String get meal_snack => 'وجبة خفيفة';

  @override
  String get home_today => 'اليوم';

  @override
  String home_streak(int count) {
    return 'سلسلة $count يوم';
  }

  @override
  String get home_empty_cta => 'سجّل وجبتك الأولى';

  @override
  String get home_fab_addMeal => 'تسجيل وجبة';

  @override
  String get home_greeting_morning => 'صباح الخير 👋';

  @override
  String get home_greeting_afternoon => 'مساء الخير 👋';

  @override
  String get home_greeting_evening => 'مساء الخير 👋';

  @override
  String get summary_consumed => 'المستهلك';

  @override
  String get summary_goal => 'الهدف';

  @override
  String summary_remaining(int kcal) {
    return 'متبقٍ $kcal سعرة';
  }

  @override
  String get history_title => 'السجل';

  @override
  String get history_tab_day => 'اليوم';

  @override
  String get history_tab_trend => 'الاتجاه';

  @override
  String get goal_title => 'هدف السعرات اليومي';

  @override
  String get goal_estimate_cta => 'احسبه لي';

  @override
  String get goal_field_height => 'الطول';

  @override
  String get goal_field_weight => 'الوزن';

  @override
  String get goal_field_activity => 'مستوى النشاط';

  @override
  String get goal_disclaimer =>
      'التقدير للاسترشاد فقط وقابل للتعديل وليس نصيحة طبية.';

  @override
  String get perm_camera_title => 'الوصول إلى الكاميرا';

  @override
  String get perm_camera_body =>
      'لالتقاط صور طعامك لتحليلها بالذكاء الاصطناعي. يُستخدم فقط عند التقاط صورة.';

  @override
  String get perm_photos_title => 'الوصول إلى الصور';

  @override
  String get perm_photos_body =>
      'لاختيار صورة طعام للتحليل. تُقرأ فقط الصورة التي تختارها.';

  @override
  String get perm_notify_title => 'تفعيل التذكيرات';

  @override
  String get perm_notify_body =>
      'يساعدك على بناء عادة التسجيل. يمكنك إيقافه في أي وقت.';

  @override
  String get perm_allow => 'السماح';

  @override
  String get perm_notNow => 'ليس الآن';

  @override
  String get perm_openSettings => 'فتح الإعدادات';

  @override
  String get settings_title => 'الإعدادات';

  @override
  String get settings_language => 'اللغة';

  @override
  String get settings_units => 'الوحدات';

  @override
  String get settings_notifications => 'الإشعارات';

  @override
  String get settings_profile => 'الملف الشخصي';

  @override
  String get settings_terms => 'شروط الخدمة';

  @override
  String get settings_privacy => 'سياسة الخصوصية';

  @override
  String get settings_about => 'حول التطبيق';

  @override
  String get settings_language_title => 'اختر اللغة';

  @override
  String get settings_language_systemDefault => 'اتّباع النظام';

  @override
  String get account_delete_entry => 'حذف الحساب';

  @override
  String get account_delete_title => 'هل تريد حذف حسابك؟';

  @override
  String get account_delete_warning =>
      'بعد الحذف، تُمحى سجلات وجباتك وصورك وملفك الشخصي وأهدافك نهائيًا ودون رجعة ولا يمكن استرجاعها.';

  @override
  String get account_delete_confirmHint => 'أدخل كلمة المرور للتأكيد';

  @override
  String get account_delete_confirmBtn => 'حذف الحساب';

  @override
  String get account_delete_success => 'تم حذف حسابك وبياناتك نهائيًا';

  @override
  String get account_delete_web => 'يمكنك أيضًا حذف حسابك عبر الويب';

  @override
  String get privacy_photo_retention =>
      'تُستخدم صور طعامك فقط للتحليل الفوري بالذكاء الاصطناعي. لا نحتفظ بالصور الأصلية لفترة طويلة؛ نحفظ فقط بيانات النتيجة المتعرّف عليها.';

  @override
  String get auth_signup_switchToLogin => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get auth_login_switchToSignup => 'ليس لديك حساب بعد؟ أنشئ حسابًا';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'أو';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'سعرة';

  @override
  String get summary_goalNotSet => 'لم يتم تحديد هدف بعد';

  @override
  String get today_mealNotLogged => 'غير مُسجّل';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'تسجيل وجبة';

  @override
  String get capture_text_title => 'صِف وجبتك';

  @override
  String get capture_camera_unavailable =>
      'الكاميرا غير متوفرة على هذا الجهاز. جرّب المعرض أو النص بدلاً من ذلك.';

  @override
  String get capture_gallery_unavailable => 'لم يتم اختيار أي صورة.';

  @override
  String get recognize_item_serving_unit_serving => 'حصة';

  @override
  String get recognize_item_serving_unit_piece => 'قطعة';

  @override
  String get recognize_item_serving_unit_gram => 'غ';

  @override
  String get recognize_editItem_title => 'تعديل العنصر';

  @override
  String get recognize_field_name => 'اسم الطعام';

  @override
  String get recognize_field_quantity => 'الكمية';

  @override
  String get recognize_field_unit => 'الوحدة';

  @override
  String get recognize_mealType_label => 'الوجبة';

  @override
  String get recognize_save_success => 'تم حفظ الوجبة';

  @override
  String get recognize_emptyItems => 'أضِف عنصرًا واحدًا على الأقل قبل الحفظ';

  @override
  String get history_prevDay => 'اليوم السابق';

  @override
  String get history_nextDay => 'اليوم التالي';

  @override
  String get history_trend_title => 'آخر 7 أيام';

  @override
  String get history_trend_caloriesLegend => 'السعرات';

  @override
  String get history_trend_goalLegend => 'الهدف';

  @override
  String get meal_delete_confirm => 'حذف هذه الوجبة؟ لا يمكن التراجع عن ذلك.';

  @override
  String get meal_delete_success => 'تم حذف الوجبة';

  @override
  String get goal_field_kcal => 'الهدف اليومي (سعرة)';

  @override
  String get goal_sex_label => 'الجنس';

  @override
  String get goal_sex_male => 'ذكر';

  @override
  String get goal_sex_female => 'أنثى';

  @override
  String get goal_field_age => 'العمر';

  @override
  String get goal_activity_sedentary => 'خامل';

  @override
  String get goal_activity_light => 'خفيف';

  @override
  String get goal_activity_moderate => 'متوسط';

  @override
  String get goal_activity_active => 'نشِط';

  @override
  String get goal_activity_veryActive => 'نشِط جدًا';

  @override
  String get goal_type_label => 'الهدف';

  @override
  String get goal_type_lose => 'إنقاص الوزن';

  @override
  String get goal_type_maintain => 'المحافظة';

  @override
  String get goal_type_gain => 'زيادة الوزن';

  @override
  String goal_estimate_result(int kcal) {
    return 'المقترح: $kcal سعرة';
  }

  @override
  String get goal_estimate_apply => 'استخدام هذه القيمة';

  @override
  String get goal_save_success => 'تم حفظ الهدف';

  @override
  String get settings_units_energy => 'الطاقة';

  @override
  String get settings_units_mass => 'الكتلة';

  @override
  String get settings_units_kcal => 'سعرة';

  @override
  String get settings_units_kj => 'كيلوجول';

  @override
  String get settings_units_g => 'غرام';

  @override
  String get settings_units_oz => 'أونصة';

  @override
  String get settings_account_section => 'الحساب';

  @override
  String get settings_dangerZone => 'منطقة الخطر';

  @override
  String get account_delete_cancel => 'إلغاء';

  @override
  String get logout_confirm => 'تسجيل الخروج من حسابك؟';

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
