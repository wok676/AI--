// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calorie Tracker';

  @override
  String get brandTagline => 'Fotografía tu comida. Conoce sus calorías.';

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_save => 'Guardar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get common_delete => 'Eliminar';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_retry => 'Reintentar';

  @override
  String get common_loading => 'Cargando…';

  @override
  String get common_empty => 'Aún no hay nada aquí';

  @override
  String get common_error_generic => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get common_error_network => 'Error de red. Comprueba tu conexión.';

  @override
  String get common_error_timeout =>
      'Se agotó el tiempo de espera. Inténtalo de nuevo.';

  @override
  String get errors_unauthorized => 'La sesión expiró, vuelve a iniciar sesión';

  @override
  String get errors_forbidden => 'No tienes permiso para realizar esta acción';

  @override
  String get errors_notFound => 'Recurso no encontrado';

  @override
  String get auth_signup_title => 'Registrarse';

  @override
  String get auth_login_title => 'Iniciar sesión';

  @override
  String get auth_field_email => 'Correo electrónico';

  @override
  String get auth_field_password => 'Contraseña';

  @override
  String get auth_password_weak => 'Contraseña débil. Usa letras y números.';

  @override
  String get auth_email_invalid => 'Dirección de correo no válida';

  @override
  String get auth_consent_label =>
      'He leído y acepto los Términos del servicio y la Política de privacidad';

  @override
  String get auth_consent_terms => 'Términos del servicio';

  @override
  String get auth_consent_privacy => 'Política de privacidad';

  @override
  String get auth_consent_required =>
      'Primero lee y acepta los Términos y la Política de privacidad';

  @override
  String get auth_apple_signin => 'Iniciar sesión con Apple';

  @override
  String get auth_google_signin => 'Iniciar sesión con Google';

  @override
  String get auth_logout => 'Cerrar sesión';

  @override
  String get auth_forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get auth_error_invalidCredentials => 'Correo o contraseña incorrectos';

  @override
  String get capture_method_photo => 'Tomar foto';

  @override
  String get capture_method_gallery => 'Elegir de la galería';

  @override
  String get capture_method_text => 'Describir con texto';

  @override
  String get capture_text_placeholder =>
      'p. ej. un plato de fideos con ternera + un huevo frito';

  @override
  String get capture_cta_recognize => 'Analizar';

  @override
  String get recognize_loading => 'Analizando tu comida…';

  @override
  String get recognize_result_title => 'Resultados';

  @override
  String get recognize_item_calories => 'Calorías';

  @override
  String get recognize_item_protein => 'Proteínas';

  @override
  String get recognize_item_carbs => 'Carbohidratos';

  @override
  String get recognize_item_fat => 'Grasas';

  @override
  String get recognize_item_serving => 'Porción';

  @override
  String get recognize_item_addManual => 'Añadir elemento manualmente';

  @override
  String get recognize_lowConfidence => 'Confianza baja: comprueba de nuevo';

  @override
  String get recognize_disclaimer =>
      'Las cifras de calorías y nutrición son estimaciones de IA y pueden ser inexactas. Solo como referencia; no son consejo médico ni de salud.';

  @override
  String get recognize_error_failed =>
      'No se pudo reconocer esta imagen. Prueba con otra foto o añádelo manualmente.';

  @override
  String get recognize_limit_reached =>
      'Has alcanzado el límite diario de reconocimientos. Inténtalo mañana.';

  @override
  String get meal_breakfast => 'Desayuno';

  @override
  String get meal_lunch => 'Almuerzo';

  @override
  String get meal_dinner => 'Cena';

  @override
  String get meal_snack => 'Tentempié';

  @override
  String get home_today => 'Hoy';

  @override
  String home_streak(int count) {
    return 'Racha de $count días';
  }

  @override
  String get home_empty_cta => 'Registra tu primera comida';

  @override
  String get home_fab_addMeal => 'Registrar una comida';

  @override
  String get home_greeting_morning => 'Buenos días 👋';

  @override
  String get home_greeting_afternoon => 'Buenas tardes 👋';

  @override
  String get home_greeting_evening => 'Buenas noches 👋';

  @override
  String get summary_consumed => 'Consumido';

  @override
  String get summary_goal => 'Objetivo';

  @override
  String summary_remaining(int kcal) {
    return 'Quedan $kcal kcal';
  }

  @override
  String get history_title => 'Historial';

  @override
  String get history_tab_day => 'Día';

  @override
  String get history_tab_trend => 'Tendencia';

  @override
  String get goal_title => 'Objetivo diario de calorías';

  @override
  String get goal_estimate_cta => 'Calcúlalo por mí';

  @override
  String get goal_field_height => 'Altura';

  @override
  String get goal_field_weight => 'Peso';

  @override
  String get goal_field_activity => 'Nivel de actividad';

  @override
  String get goal_disclaimer =>
      'La estimación es solo de referencia, ajustable y no constituye consejo médico.';

  @override
  String get perm_camera_title => 'Acceso a la cámara';

  @override
  String get perm_camera_body =>
      'Para fotografiar tu comida y analizarla con IA. Solo se usa cuando tomas una foto.';

  @override
  String get perm_photos_title => 'Acceso a las fotos';

  @override
  String get perm_photos_body =>
      'Para elegir una foto de comida y analizarla. Solo se lee la foto que selecciones.';

  @override
  String get perm_notify_title => 'Activar recordatorios';

  @override
  String get perm_notify_body =>
      'Te ayuda a crear el hábito de registrar. Puedes desactivarlo cuando quieras.';

  @override
  String get perm_allow => 'Permitir';

  @override
  String get perm_notNow => 'Ahora no';

  @override
  String get perm_openSettings => 'Abrir Ajustes';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_units => 'Unidades';

  @override
  String get settings_notifications => 'Notificaciones';

  @override
  String get settings_profile => 'Perfil';

  @override
  String get settings_terms => 'Términos del servicio';

  @override
  String get settings_privacy => 'Política de privacidad';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_language_title => 'Elige el idioma';

  @override
  String get settings_language_systemDefault => 'Según el sistema';

  @override
  String get account_delete_entry => 'Eliminar cuenta';

  @override
  String get account_delete_title => '¿Eliminar tu cuenta?';

  @override
  String get account_delete_warning =>
      'Una vez eliminada, tus registros de comidas, fotos, perfil y objetivos se borran de forma permanente e irreversible y no se pueden recuperar.';

  @override
  String get account_delete_confirmHint =>
      'Introduce tu contraseña para confirmar';

  @override
  String get account_delete_confirmBtn => 'Eliminar cuenta';

  @override
  String get account_delete_success =>
      'Tu cuenta y tus datos se han eliminado permanentemente';

  @override
  String get account_delete_web =>
      'También puedes eliminar tu cuenta desde la web';

  @override
  String get privacy_photo_retention =>
      'Tus fotos de comida solo se usan para el análisis instantáneo con IA. Las imágenes originales no se conservan a largo plazo; solo guardamos los datos del resultado reconocido.';

  @override
  String get auth_signup_switchToLogin => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get auth_login_switchToSignup => '¿Aún no tienes cuenta? Regístrate';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'o';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'Aún no se ha fijado un objetivo';

  @override
  String get today_mealNotLogged => 'Sin registrar';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'Registrar una comida';

  @override
  String get capture_text_title => 'Describe tu comida';

  @override
  String get capture_camera_unavailable =>
      'La cámara no está disponible en este dispositivo. Usa la galería o el texto.';

  @override
  String get capture_gallery_unavailable =>
      'No se ha seleccionado ninguna foto.';

  @override
  String get recognize_item_serving_unit_serving => 'porción';

  @override
  String get recognize_item_serving_unit_piece => 'pieza';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => 'Editar elemento';

  @override
  String get recognize_field_name => 'Nombre del alimento';

  @override
  String get recognize_field_quantity => 'Cantidad';

  @override
  String get recognize_field_unit => 'Unidad';

  @override
  String get recognize_mealType_label => 'Comida';

  @override
  String get recognize_save_success => 'Comida guardada';

  @override
  String get recognize_emptyItems =>
      'Añade al menos un elemento antes de guardar';

  @override
  String get history_prevDay => 'Día anterior';

  @override
  String get history_nextDay => 'Día siguiente';

  @override
  String get history_trend_title => 'Últimos 7 días';

  @override
  String get history_trend_caloriesLegend => 'Calorías';

  @override
  String get history_trend_goalLegend => 'Objetivo';

  @override
  String get meal_delete_confirm =>
      '¿Eliminar esta comida? No se puede deshacer.';

  @override
  String get meal_delete_success => 'Comida eliminada';

  @override
  String get goal_field_kcal => 'Objetivo diario (kcal)';

  @override
  String get goal_sex_label => 'Sexo';

  @override
  String get goal_sex_male => 'Hombre';

  @override
  String get goal_sex_female => 'Mujer';

  @override
  String get goal_field_age => 'Edad';

  @override
  String get goal_activity_sedentary => 'Sedentario';

  @override
  String get goal_activity_light => 'Ligera';

  @override
  String get goal_activity_moderate => 'Moderada';

  @override
  String get goal_activity_active => 'Activa';

  @override
  String get goal_activity_veryActive => 'Muy activa';

  @override
  String get goal_type_label => 'Objetivo';

  @override
  String get goal_type_lose => 'Bajar de peso';

  @override
  String get goal_type_maintain => 'Mantener';

  @override
  String get goal_type_gain => 'Aumentar de peso';

  @override
  String goal_estimate_result(int kcal) {
    return 'Sugerido: $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'Usar este valor';

  @override
  String get goal_save_success => 'Objetivo guardado';

  @override
  String get settings_units_energy => 'Energía';

  @override
  String get settings_units_mass => 'Masa';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'gramos';

  @override
  String get settings_units_oz => 'onzas';

  @override
  String get settings_account_section => 'Cuenta';

  @override
  String get settings_dangerZone => 'Zona de riesgo';

  @override
  String get account_delete_cancel => 'Cancelar';

  @override
  String get logout_confirm => '¿Cerrar sesión en tu cuenta?';

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
