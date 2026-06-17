// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '칼로리 트래커';

  @override
  String get brandTagline => '식사를 찍으면 칼로리를 알 수 있어요.';

  @override
  String get common_continue => '계속';

  @override
  String get common_save => '저장';

  @override
  String get common_cancel => '취소';

  @override
  String get common_confirm => '확인';

  @override
  String get common_delete => '삭제';

  @override
  String get common_edit => '편집';

  @override
  String get common_retry => '다시 시도';

  @override
  String get common_loading => '불러오는 중…';

  @override
  String get common_empty => '아직 아무것도 없어요';

  @override
  String get common_error_generic => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get common_error_network => '네트워크 오류입니다. 연결을 확인해 주세요.';

  @override
  String get common_error_timeout => '요청 시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get errors_unauthorized => '세션이 만료되었습니다. 다시 로그인해 주세요';

  @override
  String get errors_forbidden => '이 작업을 수행할 권한이 없습니다';

  @override
  String get errors_notFound => '리소스를 찾을 수 없습니다';

  @override
  String get auth_signup_title => '회원가입';

  @override
  String get auth_login_title => '로그인';

  @override
  String get auth_field_email => '이메일';

  @override
  String get auth_field_password => '비밀번호';

  @override
  String get auth_password_weak => '비밀번호가 약합니다. 영문과 숫자를 사용하세요.';

  @override
  String get auth_email_invalid => '잘못된 이메일 주소입니다';

  @override
  String get auth_consent_label => '서비스 약관과 개인정보 처리방침을 읽었으며 이에 동의합니다';

  @override
  String get auth_consent_terms => '서비스 약관';

  @override
  String get auth_consent_privacy => '개인정보 처리방침';

  @override
  String get auth_consent_required => '먼저 약관과 개인정보 처리방침을 읽고 동의해 주세요';

  @override
  String get auth_apple_signin => 'Apple로 로그인';

  @override
  String get auth_google_signin => 'Google로 로그인';

  @override
  String get auth_logout => '로그아웃';

  @override
  String get auth_forgotPassword => '비밀번호 찾기';

  @override
  String get auth_error_invalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get capture_method_photo => '사진 촬영';

  @override
  String get capture_method_gallery => '갤러리에서 선택';

  @override
  String get capture_method_text => '텍스트로 입력';

  @override
  String get capture_text_placeholder => '예: 소고기 국수 한 그릇 + 계란프라이 하나';

  @override
  String get capture_cta_recognize => '분석하기';

  @override
  String get recognize_loading => '음식을 분석하는 중…';

  @override
  String get recognize_result_title => '결과';

  @override
  String get recognize_item_calories => '칼로리';

  @override
  String get recognize_item_protein => '단백질';

  @override
  String get recognize_item_carbs => '탄수화물';

  @override
  String get recognize_item_fat => '지방';

  @override
  String get recognize_item_serving => '1회 제공량';

  @override
  String get recognize_item_addManual => '항목 직접 추가';

  @override
  String get recognize_lowConfidence => '신뢰도가 낮습니다 — 다시 확인해 주세요';

  @override
  String get recognize_disclaimer =>
      '칼로리 및 영양 수치는 AI 추정값으로 정확하지 않을 수 있습니다. 참고용이며 의학적·건강상의 조언이 아닙니다.';

  @override
  String get recognize_error_failed =>
      '이 이미지를 인식하지 못했습니다. 다른 사진을 시도하거나 직접 추가하세요.';

  @override
  String get recognize_limit_reached => '오늘 인식 한도에 도달했습니다. 내일 다시 시도해 주세요.';

  @override
  String get meal_breakfast => '아침';

  @override
  String get meal_lunch => '점심';

  @override
  String get meal_dinner => '저녁';

  @override
  String get meal_snack => '간식';

  @override
  String get home_today => '오늘';

  @override
  String home_streak(int count) {
    return '$count일 연속';
  }

  @override
  String get home_empty_cta => '첫 식사를 기록해 보세요';

  @override
  String get home_fab_addMeal => '식사 기록';

  @override
  String get home_greeting_morning => '좋은 아침이에요 👋';

  @override
  String get home_greeting_afternoon => '안녕하세요 👋';

  @override
  String get home_greeting_evening => '좋은 저녁이에요 👋';

  @override
  String get summary_consumed => '섭취';

  @override
  String get summary_goal => '목표';

  @override
  String summary_remaining(int kcal) {
    return '${kcal}kcal 남음';
  }

  @override
  String get history_title => '기록';

  @override
  String get history_tab_day => '일별';

  @override
  String get history_tab_trend => '추이';

  @override
  String get goal_title => '일일 칼로리 목표';

  @override
  String get goal_estimate_cta => '추천값 계산';

  @override
  String get goal_field_height => '키';

  @override
  String get goal_field_weight => '체중';

  @override
  String get goal_field_activity => '활동량';

  @override
  String get goal_disclaimer => '추정값은 참고용이며 조정할 수 있고 의학적 조언이 아닙니다.';

  @override
  String get perm_camera_title => '카메라 접근';

  @override
  String get perm_camera_body => 'AI 분석을 위해 음식 사진을 촬영합니다. 사진을 찍을 때만 사용됩니다.';

  @override
  String get perm_photos_title => '사진 접근';

  @override
  String get perm_photos_body => '분석할 음식 사진을 선택하기 위해서입니다. 선택한 사진만 읽습니다.';

  @override
  String get perm_notify_title => '알림 켜기';

  @override
  String get perm_notify_body => '기록 습관을 만드는 데 도움이 됩니다. 언제든 끌 수 있습니다.';

  @override
  String get perm_allow => '허용';

  @override
  String get perm_notNow => '나중에';

  @override
  String get perm_openSettings => '설정 열기';

  @override
  String get settings_title => '설정';

  @override
  String get settings_language => '언어';

  @override
  String get settings_units => '단위';

  @override
  String get settings_notifications => '알림';

  @override
  String get settings_profile => '프로필';

  @override
  String get settings_terms => '서비스 약관';

  @override
  String get settings_privacy => '개인정보 처리방침';

  @override
  String get settings_about => '정보';

  @override
  String get settings_language_title => '언어 선택';

  @override
  String get settings_language_systemDefault => '시스템 설정 따르기';

  @override
  String get account_delete_entry => '계정 삭제';

  @override
  String get account_delete_title => '계정을 삭제하시겠어요?';

  @override
  String get account_delete_warning =>
      '삭제하면 식사 기록, 사진, 프로필, 목표가 영구적이고 되돌릴 수 없게 지워지며 복구할 수 없습니다.';

  @override
  String get account_delete_confirmHint => '확인을 위해 비밀번호를 입력하세요';

  @override
  String get account_delete_confirmBtn => '계정 삭제';

  @override
  String get account_delete_success => '계정과 데이터가 영구적으로 삭제되었습니다';

  @override
  String get account_delete_web => '웹에서도 계정을 삭제할 수 있습니다';

  @override
  String get privacy_photo_retention =>
      '음식 사진은 즉각적인 AI 분석에만 사용됩니다. 원본 이미지는 장기간 보관하지 않으며 인식된 결과 데이터만 보관합니다.';

  @override
  String get auth_signup_switchToLogin => '이미 계정이 있나요? 로그인';

  @override
  String get auth_login_switchToSignup => '아직 계정이 없나요? 회원가입';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => '또는';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => '아직 목표가 설정되지 않았습니다';

  @override
  String get today_mealNotLogged => '기록 안 함';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 항목',
      one: '1개 항목',
      zero: '항목 없음',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => '식사 기록';

  @override
  String get capture_text_title => '식사를 설명해 주세요';

  @override
  String get capture_camera_unavailable =>
      '이 기기에서는 카메라를 사용할 수 없습니다. 대신 갤러리나 텍스트를 이용하세요.';

  @override
  String get capture_gallery_unavailable => '선택된 사진이 없습니다.';

  @override
  String get recognize_item_serving_unit_serving => '인분';

  @override
  String get recognize_item_serving_unit_piece => '개';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => '항목 편집';

  @override
  String get recognize_field_name => '음식 이름';

  @override
  String get recognize_field_quantity => '수량';

  @override
  String get recognize_field_unit => '단위';

  @override
  String get recognize_mealType_label => '식사';

  @override
  String get recognize_save_success => '식사가 저장되었습니다';

  @override
  String get recognize_emptyItems => '저장하기 전에 항목을 하나 이상 추가하세요';

  @override
  String get history_prevDay => '이전 날';

  @override
  String get history_nextDay => '다음 날';

  @override
  String get history_trend_title => '최근 7일';

  @override
  String get history_trend_caloriesLegend => '칼로리';

  @override
  String get history_trend_goalLegend => '목표';

  @override
  String get meal_delete_confirm => '이 식사를 삭제할까요? 되돌릴 수 없습니다.';

  @override
  String get meal_delete_success => '식사가 삭제되었습니다';

  @override
  String get goal_field_kcal => '일일 목표 (kcal)';

  @override
  String get goal_sex_label => '성별';

  @override
  String get goal_sex_male => '남성';

  @override
  String get goal_sex_female => '여성';

  @override
  String get goal_field_age => '나이';

  @override
  String get goal_activity_sedentary => '거의 안 움직임';

  @override
  String get goal_activity_light => '가벼움';

  @override
  String get goal_activity_moderate => '보통';

  @override
  String get goal_activity_active => '활동적';

  @override
  String get goal_activity_veryActive => '매우 활동적';

  @override
  String get goal_type_label => '목표';

  @override
  String get goal_type_lose => '감량';

  @override
  String get goal_type_maintain => '유지';

  @override
  String get goal_type_gain => '증량';

  @override
  String goal_estimate_result(int kcal) {
    return '추천: ${kcal}kcal';
  }

  @override
  String get goal_estimate_apply => '이 값 사용';

  @override
  String get goal_save_success => '목표가 저장되었습니다';

  @override
  String get settings_units_energy => '에너지';

  @override
  String get settings_units_mass => '질량';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => '그램';

  @override
  String get settings_units_oz => '온스';

  @override
  String get settings_account_section => '계정';

  @override
  String get settings_dangerZone => '위험 구역';

  @override
  String get account_delete_cancel => '취소';

  @override
  String get logout_confirm => '계정에서 로그아웃하시겠어요?';

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
