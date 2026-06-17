// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'カロリートラッカー';

  @override
  String get brandTagline => '食事を撮るだけ。カロリーがわかる。';

  @override
  String get common_continue => '続ける';

  @override
  String get common_save => '保存';

  @override
  String get common_cancel => 'キャンセル';

  @override
  String get common_confirm => '確定';

  @override
  String get common_delete => '削除';

  @override
  String get common_edit => '編集';

  @override
  String get common_retry => '再試行';

  @override
  String get common_loading => '読み込み中…';

  @override
  String get common_empty => 'まだ何もありません';

  @override
  String get common_error_generic => '問題が発生しました。もう一度お試しください。';

  @override
  String get common_error_network => 'ネットワークエラー。接続を確認してください。';

  @override
  String get common_error_timeout => 'リクエストがタイムアウトしました。もう一度お試しください。';

  @override
  String get errors_unauthorized => 'セッションが切れました。再度ログインしてください';

  @override
  String get errors_forbidden => 'この操作を行う権限がありません';

  @override
  String get errors_notFound => 'リソースが見つかりません';

  @override
  String get auth_signup_title => '新規登録';

  @override
  String get auth_login_title => 'ログイン';

  @override
  String get auth_field_email => 'メールアドレス';

  @override
  String get auth_field_password => 'パスワード';

  @override
  String get auth_password_weak => 'パスワードが脆弱です。英字と数字を使ってください。';

  @override
  String get auth_email_invalid => 'メールアドレスが無効です';

  @override
  String get auth_consent_label => '利用規約とプライバシーポリシーを読み、同意します';

  @override
  String get auth_consent_terms => '利用規約';

  @override
  String get auth_consent_privacy => 'プライバシーポリシー';

  @override
  String get auth_consent_required => '先に利用規約とプライバシーポリシーを読み、同意してください';

  @override
  String get auth_apple_signin => 'Appleでサインイン';

  @override
  String get auth_google_signin => 'Googleでサインイン';

  @override
  String get auth_logout => 'ログアウト';

  @override
  String get auth_forgotPassword => 'パスワードをお忘れですか';

  @override
  String get auth_error_invalidCredentials => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get capture_method_photo => '写真を撮る';

  @override
  String get capture_method_gallery => 'ギャラリーから選ぶ';

  @override
  String get capture_method_text => 'テキストで入力';

  @override
  String get capture_text_placeholder => '例：牛肉麺一杯 + 目玉焼き一つ';

  @override
  String get capture_cta_recognize => '分析する';

  @override
  String get recognize_loading => '食事を分析しています…';

  @override
  String get recognize_result_title => '結果';

  @override
  String get recognize_item_calories => 'カロリー';

  @override
  String get recognize_item_protein => 'タンパク質';

  @override
  String get recognize_item_carbs => '炭水化物';

  @override
  String get recognize_item_fat => '脂質';

  @override
  String get recognize_item_serving => '分量';

  @override
  String get recognize_item_addManual => '項目を手動で追加';

  @override
  String get recognize_lowConfidence => '信頼度が低めです。ご確認ください';

  @override
  String get recognize_disclaimer =>
      'カロリーや栄養の数値はAIによる推定値で、正確でない場合があります。参考用であり、医療・健康に関する助言ではありません。';

  @override
  String get recognize_error_failed => 'この画像を認識できませんでした。別の写真を試すか、手動で追加してください。';

  @override
  String get recognize_limit_reached => '本日の認識回数の上限に達しました。明日またお試しください。';

  @override
  String get meal_breakfast => '朝食';

  @override
  String get meal_lunch => '昼食';

  @override
  String get meal_dinner => '夕食';

  @override
  String get meal_snack => '間食';

  @override
  String get home_today => '今日';

  @override
  String home_streak(int count) {
    return '$count日連続';
  }

  @override
  String get home_empty_cta => '最初の食事を記録しましょう';

  @override
  String get home_fab_addMeal => '食事を記録';

  @override
  String get home_greeting_morning => 'おはようございます 👋';

  @override
  String get home_greeting_afternoon => 'こんにちは 👋';

  @override
  String get home_greeting_evening => 'こんばんは 👋';

  @override
  String get summary_consumed => '摂取';

  @override
  String get summary_goal => '目標';

  @override
  String summary_remaining(int kcal) {
    return '残り${kcal}kcal';
  }

  @override
  String get history_title => '履歴';

  @override
  String get history_tab_day => '日';

  @override
  String get history_tab_trend => '推移';

  @override
  String get goal_title => '1日のカロリー目標';

  @override
  String get goal_estimate_cta => 'おすすめを計算';

  @override
  String get goal_field_height => '身長';

  @override
  String get goal_field_weight => '体重';

  @override
  String get goal_field_activity => '活動量';

  @override
  String get goal_disclaimer => '推定値は参考用で調整可能であり、医療上の助言ではありません。';

  @override
  String get perm_camera_title => 'カメラへのアクセス';

  @override
  String get perm_camera_body => 'AI分析のために食事の写真を撮影します。撮影時のみ使用します。';

  @override
  String get perm_photos_title => '写真へのアクセス';

  @override
  String get perm_photos_body => '分析する食事の写真を選ぶために使用します。選択した写真のみを読み込みます。';

  @override
  String get perm_notify_title => 'リマインダーを有効にする';

  @override
  String get perm_notify_body => '記録の習慣づくりをサポートします。いつでもオフにできます。';

  @override
  String get perm_allow => '許可';

  @override
  String get perm_notNow => '後で';

  @override
  String get perm_openSettings => '設定を開く';

  @override
  String get settings_title => '設定';

  @override
  String get settings_language => '言語';

  @override
  String get settings_units => '単位';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_profile => 'プロフィール';

  @override
  String get settings_terms => '利用規約';

  @override
  String get settings_privacy => 'プライバシーポリシー';

  @override
  String get settings_about => 'アプリについて';

  @override
  String get settings_language_title => '言語を選択';

  @override
  String get settings_language_systemDefault => 'システムに従う';

  @override
  String get account_delete_entry => 'アカウントを削除';

  @override
  String get account_delete_title => 'アカウントを削除しますか？';

  @override
  String get account_delete_warning =>
      '削除すると、食事記録・写真・プロフィール・目標は完全かつ取り消し不能に消去され、復元できません。';

  @override
  String get account_delete_confirmHint => '確認のためパスワードを入力してください';

  @override
  String get account_delete_confirmBtn => 'アカウントを削除';

  @override
  String get account_delete_success => 'アカウントとデータは完全に削除されました';

  @override
  String get account_delete_web => 'ウェブからもアカウントを削除できます';

  @override
  String get privacy_photo_retention =>
      '食事の写真はその場のAI分析にのみ使用します。元画像は長期保存せず、認識結果のデータのみを保持します。';

  @override
  String get auth_signup_switchToLogin => 'アカウントをお持ちですか？ログイン';

  @override
  String get auth_login_switchToSignup => 'アカウントをお持ちでないですか？新規登録';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'または';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => '目標が未設定です';

  @override
  String get today_mealNotLogged => '未記録';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項目',
      one: '1 項目',
      zero: '項目なし',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => '食事を記録';

  @override
  String get capture_text_title => '食事の内容を入力';

  @override
  String get capture_camera_unavailable =>
      'この端末ではカメラを利用できません。ギャラリーかテキストをお使いください。';

  @override
  String get capture_gallery_unavailable => '写真が選択されていません。';

  @override
  String get recognize_item_serving_unit_serving => '人前';

  @override
  String get recognize_item_serving_unit_piece => '個';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => '項目を編集';

  @override
  String get recognize_field_name => '食品名';

  @override
  String get recognize_field_quantity => '数量';

  @override
  String get recognize_field_unit => '単位';

  @override
  String get recognize_mealType_label => '食事';

  @override
  String get recognize_save_success => '食事を保存しました';

  @override
  String get recognize_emptyItems => '保存する前に少なくとも1項目を追加してください';

  @override
  String get history_prevDay => '前日';

  @override
  String get history_nextDay => '翌日';

  @override
  String get history_trend_title => '過去7日間';

  @override
  String get history_trend_caloriesLegend => 'カロリー';

  @override
  String get history_trend_goalLegend => '目標';

  @override
  String get meal_delete_confirm => 'この食事を削除しますか？元に戻せません。';

  @override
  String get meal_delete_success => '食事を削除しました';

  @override
  String get goal_field_kcal => '1日の目標（kcal）';

  @override
  String get goal_sex_label => '性別';

  @override
  String get goal_sex_male => '男性';

  @override
  String get goal_sex_female => '女性';

  @override
  String get goal_field_age => '年齢';

  @override
  String get goal_activity_sedentary => '座りがち';

  @override
  String get goal_activity_light => '軽い';

  @override
  String get goal_activity_moderate => 'ふつう';

  @override
  String get goal_activity_active => '活発';

  @override
  String get goal_activity_veryActive => 'とても活発';

  @override
  String get goal_type_label => '目標';

  @override
  String get goal_type_lose => '減量';

  @override
  String get goal_type_maintain => '維持';

  @override
  String get goal_type_gain => '増量';

  @override
  String goal_estimate_result(int kcal) {
    return 'おすすめ：$kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'この値を使う';

  @override
  String get goal_save_success => '目標を保存しました';

  @override
  String get settings_units_energy => 'エネルギー';

  @override
  String get settings_units_mass => '重さ';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'グラム';

  @override
  String get settings_units_oz => 'オンス';

  @override
  String get settings_account_section => 'アカウント';

  @override
  String get settings_dangerZone => '危険な操作';

  @override
  String get account_delete_cancel => 'キャンセル';

  @override
  String get logout_confirm => 'アカウントからログアウトしますか？';

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
