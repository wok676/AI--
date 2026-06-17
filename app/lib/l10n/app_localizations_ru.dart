// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Calorie Tracker';

  @override
  String get brandTagline => 'Сфотографируйте блюдо. Узнайте калории.';

  @override
  String get common_continue => 'Продолжить';

  @override
  String get common_save => 'Сохранить';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_confirm => 'Подтвердить';

  @override
  String get common_delete => 'Удалить';

  @override
  String get common_edit => 'Изменить';

  @override
  String get common_retry => 'Повторить';

  @override
  String get common_loading => 'Загрузка…';

  @override
  String get common_empty => 'Здесь пока пусто';

  @override
  String get common_error_generic => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get common_error_network => 'Ошибка сети. Проверьте подключение.';

  @override
  String get common_error_timeout =>
      'Время ожидания истекло. Попробуйте снова.';

  @override
  String get errors_unauthorized => 'Сеанс истёк, войдите снова';

  @override
  String get errors_forbidden => 'У вас нет прав для этого действия';

  @override
  String get errors_notFound => 'Ресурс не найден';

  @override
  String get auth_signup_title => 'Регистрация';

  @override
  String get auth_login_title => 'Вход';

  @override
  String get auth_field_email => 'Эл. почта';

  @override
  String get auth_field_password => 'Пароль';

  @override
  String get auth_password_weak => 'Слабый пароль. Используйте буквы и цифры.';

  @override
  String get auth_email_invalid => 'Неверный адрес эл. почты';

  @override
  String get auth_consent_label =>
      'Я прочитал(а) и принимаю Условия использования и Политику конфиденциальности';

  @override
  String get auth_consent_terms => 'Условия использования';

  @override
  String get auth_consent_privacy => 'Политика конфиденциальности';

  @override
  String get auth_consent_required =>
      'Сначала прочтите и примите Условия и Политику конфиденциальности';

  @override
  String get auth_apple_signin => 'Войти через Apple';

  @override
  String get auth_google_signin => 'Войти через Google';

  @override
  String get auth_logout => 'Выйти';

  @override
  String get auth_forgotPassword => 'Забыли пароль';

  @override
  String get auth_error_invalidCredentials => 'Неверная почта или пароль';

  @override
  String get capture_method_photo => 'Сделать фото';

  @override
  String get capture_method_gallery => 'Выбрать из галереи';

  @override
  String get capture_method_text => 'Описать текстом';

  @override
  String get capture_text_placeholder =>
      'напр.: миска лапши с говядиной + жареное яйцо';

  @override
  String get capture_cta_recognize => 'Анализировать';

  @override
  String get recognize_loading => 'Анализируем вашу еду…';

  @override
  String get recognize_result_title => 'Результаты';

  @override
  String get recognize_item_calories => 'Калории';

  @override
  String get recognize_item_protein => 'Белки';

  @override
  String get recognize_item_carbs => 'Углеводы';

  @override
  String get recognize_item_fat => 'Жиры';

  @override
  String get recognize_item_serving => 'Порция';

  @override
  String get recognize_item_addManual => 'Добавить вручную';

  @override
  String get recognize_lowConfidence => 'Низкая точность — перепроверьте';

  @override
  String get recognize_disclaimer =>
      'Данные о калориях и питательности — оценки ИИ и могут быть неточными. Только для справки; это не медицинская рекомендация.';

  @override
  String get recognize_error_failed =>
      'Не удалось распознать изображение. Попробуйте другое фото или добавьте вручную.';

  @override
  String get recognize_limit_reached =>
      'Достигнут дневной лимит распознаваний. Попробуйте завтра.';

  @override
  String get meal_breakfast => 'Завтрак';

  @override
  String get meal_lunch => 'Обед';

  @override
  String get meal_dinner => 'Ужин';

  @override
  String get meal_snack => 'Перекус';

  @override
  String get home_today => 'Сегодня';

  @override
  String home_streak(int count) {
    return 'Серия $count дн.';
  }

  @override
  String get home_empty_cta => 'Запишите первый приём пищи';

  @override
  String get home_fab_addMeal => 'Записать приём пищи';

  @override
  String get home_greeting_morning => 'Доброе утро 👋';

  @override
  String get home_greeting_afternoon => 'Добрый день 👋';

  @override
  String get home_greeting_evening => 'Добрый вечер 👋';

  @override
  String get summary_consumed => 'Потреблено';

  @override
  String get summary_goal => 'Цель';

  @override
  String summary_remaining(int kcal) {
    return 'Осталось $kcal ккал';
  }

  @override
  String get history_title => 'История';

  @override
  String get history_tab_day => 'День';

  @override
  String get history_tab_trend => 'Тренд';

  @override
  String get goal_title => 'Дневная норма калорий';

  @override
  String get goal_estimate_cta => 'Рассчитать за меня';

  @override
  String get goal_field_height => 'Рост';

  @override
  String get goal_field_weight => 'Вес';

  @override
  String get goal_field_activity => 'Уровень активности';

  @override
  String get goal_disclaimer =>
      'Оценка приведена для справки, её можно изменить; это не медицинская рекомендация.';

  @override
  String get perm_camera_title => 'Доступ к камере';

  @override
  String get perm_camera_body =>
      'Чтобы фотографировать еду для анализа ИИ. Используется только при съёмке.';

  @override
  String get perm_photos_title => 'Доступ к фото';

  @override
  String get perm_photos_body =>
      'Чтобы выбрать фото еды для анализа. Читается только выбранное вами фото.';

  @override
  String get perm_notify_title => 'Включить напоминания';

  @override
  String get perm_notify_body =>
      'Помогает выработать привычку записывать. Можно отключить в любой момент.';

  @override
  String get perm_allow => 'Разрешить';

  @override
  String get perm_notNow => 'Не сейчас';

  @override
  String get perm_openSettings => 'Открыть настройки';

  @override
  String get settings_title => 'Настройки';

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_units => 'Единицы';

  @override
  String get settings_notifications => 'Уведомления';

  @override
  String get settings_profile => 'Профиль';

  @override
  String get settings_terms => 'Условия использования';

  @override
  String get settings_privacy => 'Политика конфиденциальности';

  @override
  String get settings_about => 'О приложении';

  @override
  String get settings_language_title => 'Выберите язык';

  @override
  String get settings_language_systemDefault => 'Как в системе';

  @override
  String get account_delete_entry => 'Удалить аккаунт';

  @override
  String get account_delete_title => 'Удалить ваш аккаунт?';

  @override
  String get account_delete_warning =>
      'После удаления ваши записи о приёмах пищи, фото, профиль и цели стираются навсегда и безвозвратно, восстановить их нельзя.';

  @override
  String get account_delete_confirmHint => 'Введите пароль для подтверждения';

  @override
  String get account_delete_confirmBtn => 'Удалить аккаунт';

  @override
  String get account_delete_success => 'Ваш аккаунт и данные удалены навсегда';

  @override
  String get account_delete_web =>
      'Вы также можете удалить аккаунт в веб-версии';

  @override
  String get privacy_photo_retention =>
      'Фото вашей еды используются только для мгновенного анализа ИИ. Исходные изображения долго не хранятся; мы сохраняем лишь данные распознанного результата.';

  @override
  String get auth_signup_switchToLogin => 'Уже есть аккаунт? Войти';

  @override
  String get auth_login_switchToSignup => 'Ещё нет аккаунта? Зарегистрируйтесь';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'или';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'ккал';

  @override
  String get summary_goalNotSet => 'Цель пока не задана';

  @override
  String get today_mealNotLogged => 'Не записано';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиций',
      one: '1 позиция',
      zero: 'Нет позиций',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'Записать приём пищи';

  @override
  String get capture_text_title => 'Опишите ваш приём пищи';

  @override
  String get capture_camera_unavailable =>
      'Камера недоступна на этом устройстве. Используйте галерею или текст.';

  @override
  String get capture_gallery_unavailable => 'Фото не выбрано.';

  @override
  String get recognize_item_serving_unit_serving => 'порция';

  @override
  String get recognize_item_serving_unit_piece => 'шт.';

  @override
  String get recognize_item_serving_unit_gram => 'г';

  @override
  String get recognize_editItem_title => 'Изменить позицию';

  @override
  String get recognize_field_name => 'Название блюда';

  @override
  String get recognize_field_quantity => 'Количество';

  @override
  String get recognize_field_unit => 'Единица';

  @override
  String get recognize_mealType_label => 'Приём пищи';

  @override
  String get recognize_save_success => 'Приём пищи сохранён';

  @override
  String get recognize_emptyItems =>
      'Добавьте хотя бы одну позицию перед сохранением';

  @override
  String get history_prevDay => 'Предыдущий день';

  @override
  String get history_nextDay => 'Следующий день';

  @override
  String get history_trend_title => 'Последние 7 дней';

  @override
  String get history_trend_caloriesLegend => 'Калории';

  @override
  String get history_trend_goalLegend => 'Цель';

  @override
  String get meal_delete_confirm =>
      'Удалить этот приём пищи? Это нельзя отменить.';

  @override
  String get meal_delete_success => 'Приём пищи удалён';

  @override
  String get goal_field_kcal => 'Дневная цель (ккал)';

  @override
  String get goal_sex_label => 'Пол';

  @override
  String get goal_sex_male => 'Мужской';

  @override
  String get goal_sex_female => 'Женский';

  @override
  String get goal_field_age => 'Возраст';

  @override
  String get goal_activity_sedentary => 'Малоподвижный';

  @override
  String get goal_activity_light => 'Лёгкая';

  @override
  String get goal_activity_moderate => 'Умеренная';

  @override
  String get goal_activity_active => 'Активная';

  @override
  String get goal_activity_veryActive => 'Очень активная';

  @override
  String get goal_type_label => 'Цель';

  @override
  String get goal_type_lose => 'Похудеть';

  @override
  String get goal_type_maintain => 'Поддерживать';

  @override
  String get goal_type_gain => 'Набрать вес';

  @override
  String goal_estimate_result(int kcal) {
    return 'Рекомендуется: $kcal ккал';
  }

  @override
  String get goal_estimate_apply => 'Использовать это значение';

  @override
  String get goal_save_success => 'Цель сохранена';

  @override
  String get settings_units_energy => 'Энергия';

  @override
  String get settings_units_mass => 'Масса';

  @override
  String get settings_units_kcal => 'ккал';

  @override
  String get settings_units_kj => 'кДж';

  @override
  String get settings_units_g => 'граммы';

  @override
  String get settings_units_oz => 'унции';

  @override
  String get settings_account_section => 'Аккаунт';

  @override
  String get settings_dangerZone => 'Опасная зона';

  @override
  String get account_delete_cancel => 'Отмена';

  @override
  String get logout_confirm => 'Выйти из аккаунта?';

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
