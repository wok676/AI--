// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कैलोरी ट्रैकर';

  @override
  String get brandTagline => 'अपने खाने की फ़ोटो लें। कैलोरी जानें।';

  @override
  String get common_continue => 'जारी रखें';

  @override
  String get common_save => 'सहेजें';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_confirm => 'पुष्टि करें';

  @override
  String get common_delete => 'हटाएँ';

  @override
  String get common_edit => 'संपादित करें';

  @override
  String get common_retry => 'पुनः प्रयास करें';

  @override
  String get common_loading => 'लोड हो रहा है…';

  @override
  String get common_empty => 'अभी यहाँ कुछ नहीं है';

  @override
  String get common_error_generic =>
      'कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें।';

  @override
  String get common_error_network =>
      'नेटवर्क त्रुटि। कृपया अपना कनेक्शन जाँचें।';

  @override
  String get common_error_timeout =>
      'अनुरोध का समय समाप्त हो गया। फिर से प्रयास करें।';

  @override
  String get errors_unauthorized =>
      'सत्र समाप्त हो गया, कृपया फिर से लॉग इन करें';

  @override
  String get errors_forbidden => 'आपको यह कार्य करने की अनुमति नहीं है';

  @override
  String get errors_notFound => 'संसाधन नहीं मिला';

  @override
  String get auth_signup_title => 'साइन अप करें';

  @override
  String get auth_login_title => 'लॉग इन करें';

  @override
  String get auth_field_email => 'ईमेल';

  @override
  String get auth_field_password => 'पासवर्ड';

  @override
  String get auth_password_weak =>
      'कमज़ोर पासवर्ड। अक्षर और संख्याएँ इस्तेमाल करें।';

  @override
  String get auth_email_invalid => 'अमान्य ईमेल पता';

  @override
  String get auth_consent_label =>
      'मैंने सेवा की शर्तें और गोपनीयता नीति पढ़ ली हैं और सहमत हूँ';

  @override
  String get auth_consent_terms => 'सेवा की शर्तें';

  @override
  String get auth_consent_privacy => 'गोपनीयता नीति';

  @override
  String get auth_consent_required =>
      'कृपया पहले शर्तें और गोपनीयता नीति पढ़कर स्वीकार करें';

  @override
  String get auth_apple_signin => 'Apple से साइन इन करें';

  @override
  String get auth_google_signin => 'Google से साइन इन करें';

  @override
  String get auth_logout => 'लॉग आउट';

  @override
  String get auth_forgotPassword => 'पासवर्ड भूल गए';

  @override
  String get auth_error_invalidCredentials => 'ईमेल या पासवर्ड गलत है';

  @override
  String get capture_method_photo => 'फ़ोटो लें';

  @override
  String get capture_method_gallery => 'गैलरी से चुनें';

  @override
  String get capture_method_text => 'टेक्स्ट में बताएँ';

  @override
  String get capture_text_placeholder =>
      'जैसे: एक कटोरी बीफ़ नूडल्स + एक तला अंडा';

  @override
  String get capture_cta_recognize => 'विश्लेषण करें';

  @override
  String get recognize_loading => 'आपके खाने का विश्लेषण हो रहा है…';

  @override
  String get recognize_result_title => 'परिणाम';

  @override
  String get recognize_item_calories => 'कैलोरी';

  @override
  String get recognize_item_protein => 'प्रोटीन';

  @override
  String get recognize_item_carbs => 'कार्ब्स';

  @override
  String get recognize_item_fat => 'वसा';

  @override
  String get recognize_item_serving => 'सर्विंग';

  @override
  String get recognize_item_addManual => 'मैन्युअल रूप से आइटम जोड़ें';

  @override
  String get recognize_lowConfidence => 'कम विश्वास — कृपया दोबारा जाँचें';

  @override
  String get recognize_disclaimer =>
      'कैलोरी और पोषण के आँकड़े AI द्वारा अनुमानित हैं और गलत हो सकते हैं। केवल संदर्भ के लिए; यह चिकित्सा या स्वास्थ्य सलाह नहीं है।';

  @override
  String get recognize_error_failed =>
      'इस तस्वीर को पहचान नहीं पाए। दूसरी फ़ोटो आज़माएँ या मैन्युअल रूप से जोड़ें।';

  @override
  String get recognize_limit_reached =>
      'आज की पहचान सीमा पूरी हो गई। कृपया कल फिर प्रयास करें।';

  @override
  String get meal_breakfast => 'नाश्ता';

  @override
  String get meal_lunch => 'दोपहर का भोजन';

  @override
  String get meal_dinner => 'रात का खाना';

  @override
  String get meal_snack => 'नाश्ता (स्नैक)';

  @override
  String get home_today => 'आज';

  @override
  String home_streak(int count) {
    return '$count दिन की लगातार रिकॉर्डिंग';
  }

  @override
  String get home_empty_cta => 'अपना पहला भोजन रिकॉर्ड करें';

  @override
  String get home_fab_addMeal => 'भोजन रिकॉर्ड करें';

  @override
  String get home_greeting_morning => 'सुप्रभात 👋';

  @override
  String get home_greeting_afternoon => 'नमस्कार 👋';

  @override
  String get home_greeting_evening => 'शुभ संध्या 👋';

  @override
  String get summary_consumed => 'लिया गया';

  @override
  String get summary_goal => 'लक्ष्य';

  @override
  String summary_remaining(int kcal) {
    return '$kcal किलोकैलोरी शेष';
  }

  @override
  String get history_title => 'इतिहास';

  @override
  String get history_tab_day => 'दिन';

  @override
  String get history_tab_trend => 'रुझान';

  @override
  String get goal_title => 'दैनिक कैलोरी लक्ष्य';

  @override
  String get goal_estimate_cta => 'मेरे लिए अनुमान लगाएँ';

  @override
  String get goal_field_height => 'ऊँचाई';

  @override
  String get goal_field_weight => 'वज़न';

  @override
  String get goal_field_activity => 'गतिविधि स्तर';

  @override
  String get goal_disclaimer =>
      'अनुमान केवल संदर्भ के लिए है, इसे समायोजित किया जा सकता है, और यह चिकित्सा सलाह नहीं है।';

  @override
  String get perm_camera_title => 'कैमरा एक्सेस';

  @override
  String get perm_camera_body =>
      'AI विश्लेषण के लिए आपके खाने की फ़ोटो लेने हेतु। केवल फ़ोटो लेते समय इस्तेमाल होता है।';

  @override
  String get perm_photos_title => 'फ़ोटो एक्सेस';

  @override
  String get perm_photos_body =>
      'विश्लेषण के लिए खाने की फ़ोटो चुनने हेतु। केवल आपकी चुनी हुई फ़ोटो पढ़ी जाती है।';

  @override
  String get perm_notify_title => 'रिमाइंडर चालू करें';

  @override
  String get perm_notify_body =>
      'रिकॉर्ड करने की आदत बनाने में मदद करता है। आप इसे कभी भी बंद कर सकते हैं।';

  @override
  String get perm_allow => 'अनुमति दें';

  @override
  String get perm_notNow => 'अभी नहीं';

  @override
  String get perm_openSettings => 'सेटिंग्स खोलें';

  @override
  String get settings_title => 'सेटिंग्स';

  @override
  String get settings_language => 'भाषा';

  @override
  String get settings_units => 'इकाइयाँ';

  @override
  String get settings_notifications => 'सूचनाएँ';

  @override
  String get settings_profile => 'प्रोफ़ाइल';

  @override
  String get settings_terms => 'सेवा की शर्तें';

  @override
  String get settings_privacy => 'गोपनीयता नीति';

  @override
  String get settings_about => 'ऐप के बारे में';

  @override
  String get settings_language_title => 'भाषा चुनें';

  @override
  String get settings_language_systemDefault => 'सिस्टम के अनुसार';

  @override
  String get account_delete_entry => 'खाता हटाएँ';

  @override
  String get account_delete_title => 'क्या आप अपना खाता हटाना चाहते हैं?';

  @override
  String get account_delete_warning =>
      'हटाने के बाद, आपके भोजन रिकॉर्ड, फ़ोटो, प्रोफ़ाइल और लक्ष्य स्थायी रूप से और अपरिवर्तनीय रूप से मिटा दिए जाएँगे और पुनर्प्राप्त नहीं किए जा सकते।';

  @override
  String get account_delete_confirmHint =>
      'पुष्टि के लिए अपना पासवर्ड दर्ज करें';

  @override
  String get account_delete_confirmBtn => 'खाता हटाएँ';

  @override
  String get account_delete_success =>
      'आपका खाता और डेटा स्थायी रूप से हटा दिया गया है';

  @override
  String get account_delete_web => 'आप अपना खाता वेब पर भी हटा सकते हैं';

  @override
  String get privacy_photo_retention =>
      'आपकी भोजन फ़ोटो केवल तत्काल AI विश्लेषण के लिए उपयोग की जाती हैं। मूल छवियाँ लंबे समय तक संग्रहीत नहीं की जातीं; हम केवल पहचाने गए परिणाम डेटा को रखते हैं।';

  @override
  String get auth_signup_switchToLogin => 'पहले से खाता है? लॉग इन करें';

  @override
  String get auth_login_switchToSignup => 'अभी तक खाता नहीं है? साइन अप करें';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'या';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'किलोकैलोरी';

  @override
  String get summary_goalNotSet => 'अभी कोई लक्ष्य निर्धारित नहीं है';

  @override
  String get today_mealNotLogged => 'रिकॉर्ड नहीं किया गया';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
      zero: 'कोई आइटम नहीं',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'भोजन रिकॉर्ड करें';

  @override
  String get capture_text_title => 'अपने भोजन का वर्णन करें';

  @override
  String get capture_camera_unavailable =>
      'इस डिवाइस पर कैमरा उपलब्ध नहीं है। इसके बजाय गैलरी या टेक्स्ट आज़माएँ।';

  @override
  String get capture_gallery_unavailable => 'कोई फ़ोटो नहीं चुनी गई।';

  @override
  String get recognize_item_serving_unit_serving => 'सर्विंग';

  @override
  String get recognize_item_serving_unit_piece => 'टुकड़ा';

  @override
  String get recognize_item_serving_unit_gram => 'ग्रा';

  @override
  String get recognize_editItem_title => 'आइटम संपादित करें';

  @override
  String get recognize_field_name => 'भोजन का नाम';

  @override
  String get recognize_field_quantity => 'मात्रा';

  @override
  String get recognize_field_unit => 'इकाई';

  @override
  String get recognize_mealType_label => 'भोजन';

  @override
  String get recognize_save_success => 'भोजन सहेजा गया';

  @override
  String get recognize_emptyItems => 'सहेजने से पहले कम से कम एक आइटम जोड़ें';

  @override
  String get history_prevDay => 'पिछला दिन';

  @override
  String get history_nextDay => 'अगला दिन';

  @override
  String get history_trend_title => 'पिछले 7 दिन';

  @override
  String get history_trend_caloriesLegend => 'कैलोरी';

  @override
  String get history_trend_goalLegend => 'लक्ष्य';

  @override
  String get meal_delete_confirm =>
      'इस भोजन को हटाएँ? यह वापस नहीं किया जा सकता।';

  @override
  String get meal_delete_success => 'भोजन हटा दिया गया';

  @override
  String get goal_field_kcal => 'दैनिक लक्ष्य (किलोकैलोरी)';

  @override
  String get goal_sex_label => 'लिंग';

  @override
  String get goal_sex_male => 'पुरुष';

  @override
  String get goal_sex_female => 'महिला';

  @override
  String get goal_field_age => 'उम्र';

  @override
  String get goal_activity_sedentary => 'बैठे रहना';

  @override
  String get goal_activity_light => 'हल्की';

  @override
  String get goal_activity_moderate => 'मध्यम';

  @override
  String get goal_activity_active => 'सक्रिय';

  @override
  String get goal_activity_veryActive => 'बहुत सक्रिय';

  @override
  String get goal_type_label => 'लक्ष्य';

  @override
  String get goal_type_lose => 'वज़न घटाना';

  @override
  String get goal_type_maintain => 'बनाए रखना';

  @override
  String get goal_type_gain => 'वज़न बढ़ाना';

  @override
  String goal_estimate_result(int kcal) {
    return 'सुझाव: $kcal किलोकैलोरी';
  }

  @override
  String get goal_estimate_apply => 'इस मान का उपयोग करें';

  @override
  String get goal_save_success => 'लक्ष्य सहेजा गया';

  @override
  String get settings_units_energy => 'ऊर्जा';

  @override
  String get settings_units_mass => 'द्रव्यमान';

  @override
  String get settings_units_kcal => 'किलोकैलोरी';

  @override
  String get settings_units_kj => 'किलोजूल';

  @override
  String get settings_units_g => 'ग्राम';

  @override
  String get settings_units_oz => 'औंस';

  @override
  String get settings_account_section => 'खाता';

  @override
  String get settings_dangerZone => 'खतरनाक क्षेत्र';

  @override
  String get account_delete_cancel => 'रद्द करें';

  @override
  String get logout_confirm => 'क्या आप अपने खाते से लॉग आउट करना चाहते हैं?';

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
