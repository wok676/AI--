// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Calorie Tracker';

  @override
  String get brandTagline => 'Fotografe sua refeição. Saiba as calorias.';

  @override
  String get common_continue => 'Continuar';

  @override
  String get common_save => 'Salvar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get common_delete => 'Excluir';

  @override
  String get common_edit => 'Editar';

  @override
  String get common_retry => 'Tentar novamente';

  @override
  String get common_loading => 'Carregando…';

  @override
  String get common_empty => 'Ainda não há nada aqui';

  @override
  String get common_error_generic => 'Algo deu errado. Tente novamente.';

  @override
  String get common_error_network => 'Erro de rede. Verifique sua conexão.';

  @override
  String get common_error_timeout => 'A solicitação expirou. Tente novamente.';

  @override
  String get errors_unauthorized => 'A sessão expirou, faça login novamente';

  @override
  String get errors_forbidden => 'Você não tem permissão para esta ação';

  @override
  String get errors_notFound => 'Recurso não encontrado';

  @override
  String get auth_signup_title => 'Cadastrar-se';

  @override
  String get auth_login_title => 'Entrar';

  @override
  String get auth_field_email => 'E-mail';

  @override
  String get auth_field_password => 'Senha';

  @override
  String get auth_password_weak => 'Senha fraca. Use letras e números.';

  @override
  String get auth_email_invalid => 'Endereço de e-mail inválido';

  @override
  String get auth_consent_label =>
      'Li e concordo com os Termos de Serviço e a Política de Privacidade';

  @override
  String get auth_consent_terms => 'Termos de Serviço';

  @override
  String get auth_consent_privacy => 'Política de Privacidade';

  @override
  String get auth_consent_required =>
      'Leia e aceite primeiro os Termos e a Política de Privacidade';

  @override
  String get auth_apple_signin => 'Entrar com a Apple';

  @override
  String get auth_google_signin => 'Entrar com o Google';

  @override
  String get auth_logout => 'Sair';

  @override
  String get auth_forgotPassword => 'Esqueceu a senha';

  @override
  String get auth_error_invalidCredentials => 'E-mail ou senha incorretos';

  @override
  String get capture_method_photo => 'Tirar foto';

  @override
  String get capture_method_gallery => 'Escolher da galeria';

  @override
  String get capture_method_text => 'Descrever em texto';

  @override
  String get capture_text_placeholder =>
      'ex.: uma tigela de macarrão com carne + um ovo frito';

  @override
  String get capture_cta_recognize => 'Analisar';

  @override
  String get recognize_loading => 'Analisando sua comida…';

  @override
  String get recognize_result_title => 'Resultados';

  @override
  String get recognize_item_calories => 'Calorias';

  @override
  String get recognize_item_protein => 'Proteínas';

  @override
  String get recognize_item_carbs => 'Carboidratos';

  @override
  String get recognize_item_fat => 'Gorduras';

  @override
  String get recognize_item_serving => 'Porção';

  @override
  String get recognize_item_addManual => 'Adicionar item manualmente';

  @override
  String get recognize_lowConfidence => 'Baixa confiança — verifique novamente';

  @override
  String get recognize_disclaimer =>
      'Os valores de calorias e nutrição são estimativas de IA e podem ser imprecisos. Apenas para referência; não são aconselhamento médico ou de saúde.';

  @override
  String get recognize_error_failed =>
      'Não foi possível reconhecer esta imagem. Tente outra foto ou adicione manualmente.';

  @override
  String get recognize_limit_reached =>
      'Limite diário de reconhecimentos atingido. Tente novamente amanhã.';

  @override
  String get meal_breakfast => 'Café da manhã';

  @override
  String get meal_lunch => 'Almoço';

  @override
  String get meal_dinner => 'Jantar';

  @override
  String get meal_snack => 'Lanche';

  @override
  String get home_today => 'Hoje';

  @override
  String home_streak(int count) {
    return 'Sequência de $count dias';
  }

  @override
  String get home_empty_cta => 'Registre sua primeira refeição';

  @override
  String get home_fab_addMeal => 'Registrar refeição';

  @override
  String get home_greeting_morning => 'Bom dia 👋';

  @override
  String get home_greeting_afternoon => 'Boa tarde 👋';

  @override
  String get home_greeting_evening => 'Boa noite 👋';

  @override
  String get summary_consumed => 'Consumido';

  @override
  String get summary_goal => 'Meta';

  @override
  String summary_remaining(int kcal) {
    return 'Restam $kcal kcal';
  }

  @override
  String get history_title => 'Histórico';

  @override
  String get history_tab_day => 'Dia';

  @override
  String get history_tab_trend => 'Tendência';

  @override
  String get goal_title => 'Meta diária de calorias';

  @override
  String get goal_estimate_cta => 'Estimar para mim';

  @override
  String get goal_field_height => 'Altura';

  @override
  String get goal_field_weight => 'Peso';

  @override
  String get goal_field_activity => 'Nível de atividade';

  @override
  String get goal_disclaimer =>
      'A estimativa é apenas para referência, ajustável e não é aconselhamento médico.';

  @override
  String get perm_camera_title => 'Acesso à câmera';

  @override
  String get perm_camera_body =>
      'Para fotografar sua comida e analisá-la com IA. Usado apenas ao tirar uma foto.';

  @override
  String get perm_photos_title => 'Acesso às fotos';

  @override
  String get perm_photos_body =>
      'Para escolher uma foto de comida e analisá-la. Somente a foto selecionada é lida.';

  @override
  String get perm_notify_title => 'Ativar lembretes';

  @override
  String get perm_notify_body =>
      'Ajuda você a criar o hábito de registrar. Pode desativar quando quiser.';

  @override
  String get perm_allow => 'Permitir';

  @override
  String get perm_notNow => 'Agora não';

  @override
  String get perm_openSettings => 'Abrir Ajustes';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_units => 'Unidades';

  @override
  String get settings_notifications => 'Notificações';

  @override
  String get settings_profile => 'Perfil';

  @override
  String get settings_terms => 'Termos de Serviço';

  @override
  String get settings_privacy => 'Política de Privacidade';

  @override
  String get settings_about => 'Sobre';

  @override
  String get settings_language_title => 'Escolha o idioma';

  @override
  String get settings_language_systemDefault => 'Seguir o sistema';

  @override
  String get account_delete_entry => 'Excluir conta';

  @override
  String get account_delete_title => 'Excluir sua conta?';

  @override
  String get account_delete_warning =>
      'Após a exclusão, seus registros de refeições, fotos, perfil e metas são apagados de forma permanente e irreversível, sem possibilidade de recuperação.';

  @override
  String get account_delete_confirmHint => 'Digite sua senha para confirmar';

  @override
  String get account_delete_confirmBtn => 'Excluir conta';

  @override
  String get account_delete_success =>
      'Sua conta e seus dados foram excluídos permanentemente';

  @override
  String get account_delete_web => 'Você também pode excluir sua conta na web';

  @override
  String get privacy_photo_retention =>
      'Suas fotos de comida são usadas apenas para a análise instantânea por IA. As imagens originais não são mantidas por muito tempo; guardamos apenas os dados do resultado reconhecido.';

  @override
  String get auth_signup_switchToLogin => 'Já tem conta? Entrar';

  @override
  String get auth_login_switchToSignup => 'Ainda não tem conta? Cadastre-se';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'ou';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'Nenhuma meta definida ainda';

  @override
  String get today_mealNotLogged => 'Não registrado';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Nenhum item',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'Registrar refeição';

  @override
  String get capture_text_title => 'Descreva sua refeição';

  @override
  String get capture_camera_unavailable =>
      'A câmera não está disponível neste dispositivo. Tente a galeria ou o texto.';

  @override
  String get capture_gallery_unavailable => 'Nenhuma foto selecionada.';

  @override
  String get recognize_item_serving_unit_serving => 'porção';

  @override
  String get recognize_item_serving_unit_piece => 'unidade';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => 'Editar item';

  @override
  String get recognize_field_name => 'Nome do alimento';

  @override
  String get recognize_field_quantity => 'Quantidade';

  @override
  String get recognize_field_unit => 'Unidade';

  @override
  String get recognize_mealType_label => 'Refeição';

  @override
  String get recognize_save_success => 'Refeição salva';

  @override
  String get recognize_emptyItems =>
      'Adicione pelo menos um item antes de salvar';

  @override
  String get history_prevDay => 'Dia anterior';

  @override
  String get history_nextDay => 'Dia seguinte';

  @override
  String get history_trend_title => 'Últimos 7 dias';

  @override
  String get history_trend_caloriesLegend => 'Calorias';

  @override
  String get history_trend_goalLegend => 'Meta';

  @override
  String get meal_delete_confirm =>
      'Excluir esta refeição? Isso não pode ser desfeito.';

  @override
  String get meal_delete_success => 'Refeição excluída';

  @override
  String get goal_field_kcal => 'Meta diária (kcal)';

  @override
  String get goal_sex_label => 'Sexo';

  @override
  String get goal_sex_male => 'Masculino';

  @override
  String get goal_sex_female => 'Feminino';

  @override
  String get goal_field_age => 'Idade';

  @override
  String get goal_activity_sedentary => 'Sedentário';

  @override
  String get goal_activity_light => 'Leve';

  @override
  String get goal_activity_moderate => 'Moderada';

  @override
  String get goal_activity_active => 'Ativa';

  @override
  String get goal_activity_veryActive => 'Muito ativa';

  @override
  String get goal_type_label => 'Meta';

  @override
  String get goal_type_lose => 'Perder peso';

  @override
  String get goal_type_maintain => 'Manter';

  @override
  String get goal_type_gain => 'Ganhar peso';

  @override
  String goal_estimate_result(int kcal) {
    return 'Sugerido: $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'Usar este valor';

  @override
  String get goal_save_success => 'Meta salva';

  @override
  String get settings_units_energy => 'Energia';

  @override
  String get settings_units_mass => 'Massa';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'gramas';

  @override
  String get settings_units_oz => 'onças';

  @override
  String get settings_account_section => 'Conta';

  @override
  String get settings_dangerZone => 'Zona de risco';

  @override
  String get account_delete_cancel => 'Cancelar';

  @override
  String get logout_confirm => 'Sair da sua conta?';

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
