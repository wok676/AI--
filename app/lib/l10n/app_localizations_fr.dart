// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calorie Tracker';

  @override
  String get brandTagline =>
      'Photographiez votre repas. Connaissez vos calories.';

  @override
  String get common_continue => 'Continuer';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get common_confirm => 'Confirmer';

  @override
  String get common_delete => 'Supprimer';

  @override
  String get common_edit => 'Modifier';

  @override
  String get common_retry => 'Réessayer';

  @override
  String get common_loading => 'Chargement…';

  @override
  String get common_empty => 'Rien ici pour l’instant';

  @override
  String get common_error_generic =>
      'Une erreur s’est produite. Veuillez réessayer.';

  @override
  String get common_error_network => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String get common_error_timeout =>
      'Délai d’attente dépassé. Veuillez réessayer.';

  @override
  String get errors_unauthorized =>
      'Session expirée, veuillez vous reconnecter';

  @override
  String get errors_forbidden =>
      'Vous n’êtes pas autorisé à effectuer cette action';

  @override
  String get errors_notFound => 'Ressource introuvable';

  @override
  String get auth_signup_title => 'S’inscrire';

  @override
  String get auth_login_title => 'Se connecter';

  @override
  String get auth_field_email => 'E-mail';

  @override
  String get auth_field_password => 'Mot de passe';

  @override
  String get auth_password_weak =>
      'Mot de passe faible. Utilisez des lettres et des chiffres.';

  @override
  String get auth_email_invalid => 'Adresse e-mail invalide';

  @override
  String get auth_consent_label =>
      'J’ai lu et j’accepte les Conditions d’utilisation et la Politique de confidentialité';

  @override
  String get auth_consent_terms => 'Conditions d’utilisation';

  @override
  String get auth_consent_privacy => 'Politique de confidentialité';

  @override
  String get auth_consent_required =>
      'Veuillez d’abord lire et accepter les Conditions et la Politique de confidentialité';

  @override
  String get auth_apple_signin => 'Se connecter avec Apple';

  @override
  String get auth_google_signin => 'Se connecter avec Google';

  @override
  String get auth_logout => 'Se déconnecter';

  @override
  String get auth_forgotPassword => 'Mot de passe oublié';

  @override
  String get auth_error_invalidCredentials =>
      'E-mail ou mot de passe incorrect';

  @override
  String get capture_method_photo => 'Prendre une photo';

  @override
  String get capture_method_gallery => 'Choisir dans la galerie';

  @override
  String get capture_method_text => 'Décrire par texte';

  @override
  String get capture_text_placeholder =>
      'ex. un bol de nouilles au bœuf + un œuf au plat';

  @override
  String get capture_cta_recognize => 'Analyser';

  @override
  String get recognize_loading => 'Analyse de votre repas…';

  @override
  String get recognize_result_title => 'Résultats';

  @override
  String get recognize_item_calories => 'Calories';

  @override
  String get recognize_item_protein => 'Protéines';

  @override
  String get recognize_item_carbs => 'Glucides';

  @override
  String get recognize_item_fat => 'Lipides';

  @override
  String get recognize_item_serving => 'Portion';

  @override
  String get recognize_item_addManual => 'Ajouter un élément manuellement';

  @override
  String get recognize_lowConfidence => 'Faible confiance — vérifiez à nouveau';

  @override
  String get recognize_disclaimer =>
      'Les valeurs caloriques et nutritionnelles sont des estimations par IA et peuvent être inexactes. À titre indicatif uniquement ; ce ne sont pas des conseils médicaux.';

  @override
  String get recognize_error_failed =>
      'Impossible de reconnaître cette image. Essayez une autre photo ou ajoutez manuellement.';

  @override
  String get recognize_limit_reached =>
      'Limite quotidienne de reconnaissances atteinte. Réessayez demain.';

  @override
  String get meal_breakfast => 'Petit-déjeuner';

  @override
  String get meal_lunch => 'Déjeuner';

  @override
  String get meal_dinner => 'Dîner';

  @override
  String get meal_snack => 'Collation';

  @override
  String get home_today => 'Aujourd’hui';

  @override
  String home_streak(int count) {
    return 'Série de $count jours';
  }

  @override
  String get home_empty_cta => 'Enregistrez votre premier repas';

  @override
  String get home_fab_addMeal => 'Enregistrer un repas';

  @override
  String get home_greeting_morning => 'Bonjour 👋';

  @override
  String get home_greeting_afternoon => 'Bon après-midi 👋';

  @override
  String get home_greeting_evening => 'Bonsoir 👋';

  @override
  String get summary_consumed => 'Consommé';

  @override
  String get summary_goal => 'Objectif';

  @override
  String summary_remaining(int kcal) {
    return '$kcal kcal restantes';
  }

  @override
  String get history_title => 'Historique';

  @override
  String get history_tab_day => 'Jour';

  @override
  String get history_tab_trend => 'Tendance';

  @override
  String get goal_title => 'Objectif calorique quotidien';

  @override
  String get goal_estimate_cta => 'Estimer pour moi';

  @override
  String get goal_field_height => 'Taille';

  @override
  String get goal_field_weight => 'Poids';

  @override
  String get goal_field_activity => 'Niveau d’activité';

  @override
  String get goal_disclaimer =>
      'L’estimation est indicative, ajustable et ne constitue pas un avis médical.';

  @override
  String get perm_camera_title => 'Accès à l’appareil photo';

  @override
  String get perm_camera_body =>
      'Pour photographier vos aliments et les analyser par IA. Utilisé uniquement lors de la prise de photo.';

  @override
  String get perm_photos_title => 'Accès aux photos';

  @override
  String get perm_photos_body =>
      'Pour choisir une photo de repas à analyser. Seule la photo sélectionnée est lue.';

  @override
  String get perm_notify_title => 'Activer les rappels';

  @override
  String get perm_notify_body =>
      'Vous aide à prendre l’habitude d’enregistrer. Désactivable à tout moment.';

  @override
  String get perm_allow => 'Autoriser';

  @override
  String get perm_notNow => 'Pas maintenant';

  @override
  String get perm_openSettings => 'Ouvrir les Réglages';

  @override
  String get settings_title => 'Réglages';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_units => 'Unités';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_profile => 'Profil';

  @override
  String get settings_terms => 'Conditions d’utilisation';

  @override
  String get settings_privacy => 'Politique de confidentialité';

  @override
  String get settings_about => 'À propos';

  @override
  String get settings_language_title => 'Choisir la langue';

  @override
  String get settings_language_systemDefault => 'Suivre le système';

  @override
  String get account_delete_entry => 'Supprimer le compte';

  @override
  String get account_delete_title => 'Supprimer votre compte ?';

  @override
  String get account_delete_warning =>
      'Une fois supprimés, vos journaux de repas, photos, profil et objectifs sont effacés de façon permanente et irréversible, sans récupération possible.';

  @override
  String get account_delete_confirmHint =>
      'Saisissez votre mot de passe pour confirmer';

  @override
  String get account_delete_confirmBtn => 'Supprimer le compte';

  @override
  String get account_delete_success =>
      'Votre compte et vos données ont été supprimés définitivement';

  @override
  String get account_delete_web =>
      'Vous pouvez aussi supprimer votre compte sur le web';

  @override
  String get privacy_photo_retention =>
      'Vos photos de repas servent uniquement à l’analyse IA instantanée. Les images originales ne sont pas conservées longtemps ; nous ne gardons que les données du résultat reconnu.';

  @override
  String get auth_signup_switchToLogin =>
      'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get auth_login_switchToSignup =>
      'Pas encore de compte ? Inscrivez-vous';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'ou';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'Aucun objectif défini pour l’instant';

  @override
  String get today_mealNotLogged => 'Non enregistré';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
      zero: 'Aucun élément',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'Enregistrer un repas';

  @override
  String get capture_text_title => 'Décrivez votre repas';

  @override
  String get capture_camera_unavailable =>
      'L’appareil photo est indisponible sur cet appareil. Essayez la galerie ou le texte.';

  @override
  String get capture_gallery_unavailable => 'Aucune photo sélectionnée.';

  @override
  String get recognize_item_serving_unit_serving => 'portion';

  @override
  String get recognize_item_serving_unit_piece => 'pièce';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => 'Modifier l’élément';

  @override
  String get recognize_field_name => 'Nom de l’aliment';

  @override
  String get recognize_field_quantity => 'Quantité';

  @override
  String get recognize_field_unit => 'Unité';

  @override
  String get recognize_mealType_label => 'Repas';

  @override
  String get recognize_save_success => 'Repas enregistré';

  @override
  String get recognize_emptyItems =>
      'Ajoutez au moins un élément avant d’enregistrer';

  @override
  String get history_prevDay => 'Jour précédent';

  @override
  String get history_nextDay => 'Jour suivant';

  @override
  String get history_trend_title => '7 derniers jours';

  @override
  String get history_trend_caloriesLegend => 'Calories';

  @override
  String get history_trend_goalLegend => 'Objectif';

  @override
  String get meal_delete_confirm =>
      'Supprimer ce repas ? Cette action est irréversible.';

  @override
  String get meal_delete_success => 'Repas supprimé';

  @override
  String get goal_field_kcal => 'Objectif quotidien (kcal)';

  @override
  String get goal_sex_label => 'Sexe';

  @override
  String get goal_sex_male => 'Homme';

  @override
  String get goal_sex_female => 'Femme';

  @override
  String get goal_field_age => 'Âge';

  @override
  String get goal_activity_sedentary => 'Sédentaire';

  @override
  String get goal_activity_light => 'Légère';

  @override
  String get goal_activity_moderate => 'Modérée';

  @override
  String get goal_activity_active => 'Active';

  @override
  String get goal_activity_veryActive => 'Très active';

  @override
  String get goal_type_label => 'Objectif';

  @override
  String get goal_type_lose => 'Perdre du poids';

  @override
  String get goal_type_maintain => 'Maintenir';

  @override
  String get goal_type_gain => 'Prendre du poids';

  @override
  String goal_estimate_result(int kcal) {
    return 'Suggéré : $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'Utiliser cette valeur';

  @override
  String get goal_save_success => 'Objectif enregistré';

  @override
  String get settings_units_energy => 'Énergie';

  @override
  String get settings_units_mass => 'Masse';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'grammes';

  @override
  String get settings_units_oz => 'onces';

  @override
  String get settings_account_section => 'Compte';

  @override
  String get settings_dangerZone => 'Zone sensible';

  @override
  String get account_delete_cancel => 'Annuler';

  @override
  String get logout_confirm => 'Se déconnecter de votre compte ?';

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
