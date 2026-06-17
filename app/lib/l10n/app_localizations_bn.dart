// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ক্যালোরি ট্র্যাকার';

  @override
  String get brandTagline => 'আপনার খাবারের ছবি তুলুন। ক্যালোরি জানুন।';

  @override
  String get common_continue => 'চালিয়ে যান';

  @override
  String get common_save => 'সংরক্ষণ';

  @override
  String get common_cancel => 'বাতিল';

  @override
  String get common_confirm => 'নিশ্চিত করুন';

  @override
  String get common_delete => 'মুছুন';

  @override
  String get common_edit => 'সম্পাদনা';

  @override
  String get common_retry => 'আবার চেষ্টা করুন';

  @override
  String get common_loading => 'লোড হচ্ছে…';

  @override
  String get common_empty => 'এখনও এখানে কিছু নেই';

  @override
  String get common_error_generic =>
      'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get common_error_network =>
      'নেটওয়ার্ক সমস্যা। আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get common_error_timeout => 'অনুরোধের সময় শেষ। আবার চেষ্টা করুন।';

  @override
  String get errors_unauthorized => 'সেশন শেষ হয়ে গেছে, আবার লগ ইন করুন';

  @override
  String get errors_forbidden => 'আপনার এই কাজটি করার অনুমতি নেই';

  @override
  String get errors_notFound => 'রিসোর্স পাওয়া যায়নি';

  @override
  String get auth_signup_title => 'সাইন আপ';

  @override
  String get auth_login_title => 'লগ ইন';

  @override
  String get auth_field_email => 'ইমেল';

  @override
  String get auth_field_password => 'পাসওয়ার্ড';

  @override
  String get auth_password_weak =>
      'দুর্বল পাসওয়ার্ড। অক্ষর ও সংখ্যা ব্যবহার করুন।';

  @override
  String get auth_email_invalid => 'অবৈধ ইমেল ঠিকানা';

  @override
  String get auth_consent_label =>
      'আমি পরিষেবার শর্তাবলী ও গোপনীয়তা নীতি পড়েছি এবং সম্মত আছি';

  @override
  String get auth_consent_terms => 'পরিষেবার শর্তাবলী';

  @override
  String get auth_consent_privacy => 'গোপনীয়তা নীতি';

  @override
  String get auth_consent_required =>
      'অনুগ্রহ করে আগে শর্তাবলী ও গোপনীয়তা নীতি পড়ে সম্মত হন';

  @override
  String get auth_apple_signin => 'Apple দিয়ে সাইন ইন';

  @override
  String get auth_google_signin => 'Google দিয়ে সাইন ইন';

  @override
  String get auth_logout => 'লগ আউট';

  @override
  String get auth_forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন';

  @override
  String get auth_error_invalidCredentials => 'ইমেল বা পাসওয়ার্ড ভুল';

  @override
  String get capture_method_photo => 'ছবি তুলুন';

  @override
  String get capture_method_gallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get capture_method_text => 'টেক্সটে বর্ণনা করুন';

  @override
  String get capture_text_placeholder =>
      'যেমন: এক বাটি বিফ নুডলস + একটি ভাজা ডিম';

  @override
  String get capture_cta_recognize => 'বিশ্লেষণ করুন';

  @override
  String get recognize_loading => 'আপনার খাবার বিশ্লেষণ করা হচ্ছে…';

  @override
  String get recognize_result_title => 'ফলাফল';

  @override
  String get recognize_item_calories => 'ক্যালোরি';

  @override
  String get recognize_item_protein => 'প্রোটিন';

  @override
  String get recognize_item_carbs => 'কার্বস';

  @override
  String get recognize_item_fat => 'ফ্যাট';

  @override
  String get recognize_item_serving => 'পরিবেশন';

  @override
  String get recognize_item_addManual => 'ম্যানুয়ালি আইটেম যোগ করুন';

  @override
  String get recognize_lowConfidence => 'নিম্ন আস্থা — অনুগ্রহ করে যাচাই করুন';

  @override
  String get recognize_disclaimer =>
      'ক্যালোরি ও পুষ্টির পরিমাণ AI-এর অনুমান এবং ভুল হতে পারে। শুধু রেফারেন্সের জন্য; এটি চিকিৎসা বা স্বাস্থ্য পরামর্শ নয়।';

  @override
  String get recognize_error_failed =>
      'এই ছবিটি শনাক্ত করা যায়নি। অন্য ছবি চেষ্টা করুন বা ম্যানুয়ালি যোগ করুন।';

  @override
  String get recognize_limit_reached =>
      'আজকের শনাক্তকরণের সীমা শেষ। আগামীকাল আবার চেষ্টা করুন।';

  @override
  String get meal_breakfast => 'সকালের খাবার';

  @override
  String get meal_lunch => 'দুপুরের খাবার';

  @override
  String get meal_dinner => 'রাতের খাবার';

  @override
  String get meal_snack => 'জলখাবার';

  @override
  String get home_today => 'আজ';

  @override
  String home_streak(int count) {
    return '$count দিনের ধারা';
  }

  @override
  String get home_empty_cta => 'আপনার প্রথম খাবার রেকর্ড করুন';

  @override
  String get home_fab_addMeal => 'একটি খাবার রেকর্ড করুন';

  @override
  String get home_greeting_morning => 'সুপ্রভাত 👋';

  @override
  String get home_greeting_afternoon => 'শুভ অপরাহ্ন 👋';

  @override
  String get home_greeting_evening => 'শুভ সন্ধ্যা 👋';

  @override
  String get summary_consumed => 'গৃহীত';

  @override
  String get summary_goal => 'লক্ষ্য';

  @override
  String summary_remaining(int kcal) {
    return '$kcal kcal বাকি';
  }

  @override
  String get history_title => 'ইতিহাস';

  @override
  String get history_tab_day => 'দিন';

  @override
  String get history_tab_trend => 'ট্রেন্ড';

  @override
  String get goal_title => 'দৈনিক ক্যালোরি লক্ষ্য';

  @override
  String get goal_estimate_cta => 'আমার জন্য হিসাব করুন';

  @override
  String get goal_field_height => 'উচ্চতা';

  @override
  String get goal_field_weight => 'ওজন';

  @override
  String get goal_field_activity => 'কার্যকলাপের মাত্রা';

  @override
  String get goal_disclaimer =>
      'অনুমানটি শুধু রেফারেন্সের জন্য, সমন্বয়যোগ্য এবং চিকিৎসা পরামর্শ নয়।';

  @override
  String get perm_camera_title => 'ক্যামেরা অ্যাক্সেস';

  @override
  String get perm_camera_body =>
      'AI বিশ্লেষণের জন্য আপনার খাবারের ছবি তুলতে। শুধু ছবি তোলার সময় ব্যবহৃত হয়।';

  @override
  String get perm_photos_title => 'ফটো অ্যাক্সেস';

  @override
  String get perm_photos_body =>
      'বিশ্লেষণের জন্য একটি খাবারের ছবি বেছে নিতে। শুধু আপনার নির্বাচিত ছবিটি পড়া হয়।';

  @override
  String get perm_notify_title => 'রিমাইন্ডার চালু করুন';

  @override
  String get perm_notify_body =>
      'রেকর্ড করার অভ্যাস গড়তে সাহায্য করে। যেকোনো সময় বন্ধ করতে পারেন।';

  @override
  String get perm_allow => 'অনুমতি দিন';

  @override
  String get perm_notNow => 'এখন নয়';

  @override
  String get perm_openSettings => 'সেটিংস খুলুন';

  @override
  String get settings_title => 'সেটিংস';

  @override
  String get settings_language => 'ভাষা';

  @override
  String get settings_units => 'একক';

  @override
  String get settings_notifications => 'বিজ্ঞপ্তি';

  @override
  String get settings_profile => 'প্রোফাইল';

  @override
  String get settings_terms => 'পরিষেবার শর্তাবলী';

  @override
  String get settings_privacy => 'গোপনীয়তা নীতি';

  @override
  String get settings_about => 'সম্পর্কে';

  @override
  String get settings_language_title => 'ভাষা নির্বাচন করুন';

  @override
  String get settings_language_systemDefault => 'সিস্টেম অনুসরণ করুন';

  @override
  String get account_delete_entry => 'অ্যাকাউন্ট মুছুন';

  @override
  String get account_delete_title => 'আপনার অ্যাকাউন্ট মুছবেন?';

  @override
  String get account_delete_warning =>
      'মুছে ফেলার পর, আপনার খাবারের রেকর্ড, ছবি, প্রোফাইল ও লক্ষ্য স্থায়ীভাবে ও অপরিবর্তনীয়ভাবে মুছে যাবে এবং পুনরুদ্ধার করা যাবে না।';

  @override
  String get account_delete_confirmHint => 'নিশ্চিত করতে আপনার পাসওয়ার্ড দিন';

  @override
  String get account_delete_confirmBtn => 'অ্যাকাউন্ট মুছুন';

  @override
  String get account_delete_success =>
      'আপনার অ্যাকাউন্ট ও ডেটা স্থায়ীভাবে মুছে ফেলা হয়েছে';

  @override
  String get account_delete_web => 'আপনি ওয়েবেও আপনার অ্যাকাউন্ট মুছতে পারেন';

  @override
  String get privacy_photo_retention =>
      'আপনার খাবারের ছবি শুধু তাৎক্ষণিক AI বিশ্লেষণের জন্য ব্যবহৃত হয়। মূল ছবি দীর্ঘমেয়াদে রাখা হয় না; আমরা কেবল শনাক্ত ফলাফলের ডেটা রাখি।';

  @override
  String get auth_signup_switchToLogin => 'ইতিমধ্যে অ্যাকাউন্ট আছে? লগ ইন করুন';

  @override
  String get auth_login_switchToSignup => 'এখনও অ্যাকাউন্ট নেই? সাইন আপ করুন';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'অথবা';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'এখনও কোনো লক্ষ্য নির্ধারণ করা হয়নি';

  @override
  String get today_mealNotLogged => 'রেকর্ড করা হয়নি';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি আইটেম',
      one: '১টি আইটেম',
      zero: 'কোনো আইটেম নেই',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'একটি খাবার রেকর্ড করুন';

  @override
  String get capture_text_title => 'আপনার খাবার বর্ণনা করুন';

  @override
  String get capture_camera_unavailable =>
      'এই ডিভাইসে ক্যামেরা উপলব্ধ নেই। পরিবর্তে গ্যালারি বা টেক্সট ব্যবহার করুন।';

  @override
  String get capture_gallery_unavailable => 'কোনো ছবি নির্বাচন করা হয়নি।';

  @override
  String get recognize_item_serving_unit_serving => 'পরিবেশন';

  @override
  String get recognize_item_serving_unit_piece => 'টুকরা';

  @override
  String get recognize_item_serving_unit_gram => 'গ্রা';

  @override
  String get recognize_editItem_title => 'আইটেম সম্পাদনা করুন';

  @override
  String get recognize_field_name => 'খাবারের নাম';

  @override
  String get recognize_field_quantity => 'পরিমাণ';

  @override
  String get recognize_field_unit => 'একক';

  @override
  String get recognize_mealType_label => 'খাবার';

  @override
  String get recognize_save_success => 'খাবার সংরক্ষিত হয়েছে';

  @override
  String get recognize_emptyItems => 'সংরক্ষণের আগে অন্তত একটি আইটেম যোগ করুন';

  @override
  String get history_prevDay => 'আগের দিন';

  @override
  String get history_nextDay => 'পরের দিন';

  @override
  String get history_trend_title => 'গত ৭ দিন';

  @override
  String get history_trend_caloriesLegend => 'ক্যালোরি';

  @override
  String get history_trend_goalLegend => 'লক্ষ্য';

  @override
  String get meal_delete_confirm => 'এই খাবারটি মুছবেন? এটি ফেরানো যাবে না।';

  @override
  String get meal_delete_success => 'খাবার মুছে ফেলা হয়েছে';

  @override
  String get goal_field_kcal => 'দৈনিক লক্ষ্য (kcal)';

  @override
  String get goal_sex_label => 'লিঙ্গ';

  @override
  String get goal_sex_male => 'পুরুষ';

  @override
  String get goal_sex_female => 'মহিলা';

  @override
  String get goal_field_age => 'বয়স';

  @override
  String get goal_activity_sedentary => 'নিষ্ক্রিয়';

  @override
  String get goal_activity_light => 'হালকা';

  @override
  String get goal_activity_moderate => 'মাঝারি';

  @override
  String get goal_activity_active => 'সক্রিয়';

  @override
  String get goal_activity_veryActive => 'খুব সক্রিয়';

  @override
  String get goal_type_label => 'লক্ষ্য';

  @override
  String get goal_type_lose => 'ওজন কমানো';

  @override
  String get goal_type_maintain => 'বজায় রাখা';

  @override
  String get goal_type_gain => 'ওজন বাড়ানো';

  @override
  String goal_estimate_result(int kcal) {
    return 'প্রস্তাবিত: $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'এই মান ব্যবহার করুন';

  @override
  String get goal_save_success => 'লক্ষ্য সংরক্ষিত হয়েছে';

  @override
  String get settings_units_energy => 'শক্তি';

  @override
  String get settings_units_mass => 'ভর';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'গ্রাম';

  @override
  String get settings_units_oz => 'আউন্স';

  @override
  String get settings_account_section => 'অ্যাকাউন্ট';

  @override
  String get settings_dangerZone => 'ঝুঁকিপূর্ণ অঞ্চল';

  @override
  String get account_delete_cancel => 'বাতিল';

  @override
  String get logout_confirm => 'আপনার অ্যাকাউন্ট থেকে লগ আউট করবেন?';

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
