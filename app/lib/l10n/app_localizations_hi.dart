// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Calorie Tracker';

  @override
  String get brandTagline => 'Snap your meal. Know your calories.';

  @override
  String get common_continue => 'Continue';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_loading => 'Loading…';

  @override
  String get common_empty => 'Nothing here yet';

  @override
  String get common_error_generic => 'Something went wrong. Please try again.';

  @override
  String get common_error_network =>
      'Network error. Please check your connection.';

  @override
  String get common_error_timeout => 'Request timed out. Please try again.';

  @override
  String get errors_unauthorized => 'Session expired, please log in again';

  @override
  String get errors_forbidden => 'You are not allowed to perform this action';

  @override
  String get errors_notFound => 'Resource not found';

  @override
  String get auth_signup_title => 'Sign up';

  @override
  String get auth_login_title => 'Log in';

  @override
  String get auth_field_email => 'Email';

  @override
  String get auth_field_password => 'Password';

  @override
  String get auth_password_weak => 'Weak password. Use letters and numbers.';

  @override
  String get auth_email_invalid => 'Invalid email address';

  @override
  String get auth_consent_label =>
      'I have read and agree to the Terms of Service and Privacy Policy';

  @override
  String get auth_consent_terms => 'Terms of Service';

  @override
  String get auth_consent_privacy => 'Privacy Policy';

  @override
  String get auth_consent_required =>
      'Please read and accept the Terms and Privacy Policy first';

  @override
  String get auth_apple_signin => 'Sign in with Apple';

  @override
  String get auth_google_signin => 'Sign in with Google';

  @override
  String get auth_logout => 'Log out';

  @override
  String get auth_forgotPassword => 'Forgot password';

  @override
  String get auth_error_invalidCredentials => 'Incorrect email or password';

  @override
  String get capture_method_photo => 'Take photo';

  @override
  String get capture_method_gallery => 'Choose from gallery';

  @override
  String get capture_method_text => 'Describe in text';

  @override
  String get capture_text_placeholder =>
      'e.g. a bowl of beef noodles + a fried egg';

  @override
  String get capture_cta_recognize => 'Analyze';

  @override
  String get recognize_loading => 'Analyzing your food…';

  @override
  String get recognize_result_title => 'Results';

  @override
  String get recognize_item_calories => 'Calories';

  @override
  String get recognize_item_protein => 'Protein';

  @override
  String get recognize_item_carbs => 'Carbs';

  @override
  String get recognize_item_fat => 'Fat';

  @override
  String get recognize_item_serving => 'Serving';

  @override
  String get recognize_item_addManual => 'Add item manually';

  @override
  String get recognize_lowConfidence => 'Low confidence — please double-check';

  @override
  String get recognize_disclaimer =>
      'Calorie and nutrition figures are AI estimates and may be inaccurate. For reference only; not medical or health advice.';

  @override
  String get recognize_error_failed =>
      'Couldn\'t recognize this image. Try another photo or add manually.';

  @override
  String get recognize_limit_reached =>
      'Daily recognition limit reached. Please try again tomorrow.';

  @override
  String get meal_breakfast => 'Breakfast';

  @override
  String get meal_lunch => 'Lunch';

  @override
  String get meal_dinner => 'Dinner';

  @override
  String get meal_snack => 'Snack';

  @override
  String get home_today => 'Today';

  @override
  String home_streak(int count) {
    return '$count-day streak';
  }

  @override
  String get home_empty_cta => 'Log your first meal';

  @override
  String get home_fab_addMeal => 'Log a meal';

  @override
  String get summary_consumed => 'Consumed';

  @override
  String get summary_goal => 'Goal';

  @override
  String summary_remaining(int kcal) {
    return '$kcal kcal left';
  }

  @override
  String get history_tab_day => 'Day';

  @override
  String get history_tab_trend => 'Trend';

  @override
  String get goal_title => 'Daily calorie goal';

  @override
  String get goal_estimate_cta => 'Estimate for me';

  @override
  String get goal_field_height => 'Height';

  @override
  String get goal_field_weight => 'Weight';

  @override
  String get goal_field_activity => 'Activity level';

  @override
  String get goal_disclaimer =>
      'Estimate is for reference only, adjustable, and not medical advice.';

  @override
  String get perm_camera_title => 'Camera access';

  @override
  String get perm_camera_body =>
      'To take photos of your food for AI analysis. Used only when you take a photo.';

  @override
  String get perm_photos_title => 'Photo access';

  @override
  String get perm_photos_body =>
      'To pick a food photo for analysis. Only the photo you select is read.';

  @override
  String get perm_notify_title => 'Enable reminders';

  @override
  String get perm_notify_body =>
      'Helps you build a logging habit. You can turn it off anytime.';

  @override
  String get perm_allow => 'Allow';

  @override
  String get perm_notNow => 'Not now';

  @override
  String get perm_openSettings => 'Open Settings';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_units => 'Units';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_profile => 'Profile';

  @override
  String get settings_terms => 'Terms of Service';

  @override
  String get settings_privacy => 'Privacy Policy';

  @override
  String get settings_about => 'About';

  @override
  String get settings_language_title => 'Choose language';

  @override
  String get settings_language_systemDefault => 'Follow system';

  @override
  String get account_delete_entry => 'Delete account';

  @override
  String get account_delete_title => 'Delete your account?';

  @override
  String get account_delete_warning =>
      'Once deleted, your meal logs, photos, profile, and goals are permanently and irreversibly erased and cannot be recovered.';

  @override
  String get account_delete_confirmHint => 'Enter your password to confirm';

  @override
  String get account_delete_confirmBtn => 'Delete account';

  @override
  String get account_delete_success =>
      'Your account and data have been permanently deleted';

  @override
  String get account_delete_web =>
      'You can also delete your account on the web';

  @override
  String get privacy_photo_retention =>
      'Your food photos are used only for instant AI analysis. Original images are not retained long-term; we keep only the recognized result data.';

  @override
  String get auth_signup_switchToLogin => 'Already have an account? Log in';

  @override
  String get auth_login_switchToSignup => 'No account yet? Sign up';

  @override
  String get auth_field_emailHint => 'you@example.com';

  @override
  String get auth_orDivider => 'or';

  @override
  String get today_dateStreakSeparator => '·';

  @override
  String get summary_unit_kcal => 'kcal';

  @override
  String get summary_goalNotSet => 'No goal set yet';

  @override
  String get today_mealNotLogged => 'Not logged';

  @override
  String today_mealItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get capture_title => 'Log a meal';

  @override
  String get capture_text_title => 'Describe your meal';

  @override
  String get capture_camera_unavailable =>
      'Camera is unavailable on this device. Try the gallery or text instead.';

  @override
  String get capture_gallery_unavailable => 'No photo selected.';

  @override
  String get recognize_item_serving_unit_serving => 'serving';

  @override
  String get recognize_item_serving_unit_piece => 'piece';

  @override
  String get recognize_item_serving_unit_gram => 'g';

  @override
  String get recognize_editItem_title => 'Edit item';

  @override
  String get recognize_field_name => 'Food name';

  @override
  String get recognize_field_quantity => 'Quantity';

  @override
  String get recognize_field_unit => 'Unit';

  @override
  String get recognize_mealType_label => 'Meal';

  @override
  String get recognize_save_success => 'Meal saved';

  @override
  String get recognize_emptyItems => 'Add at least one item before saving';

  @override
  String get history_prevDay => 'Previous day';

  @override
  String get history_nextDay => 'Next day';

  @override
  String get history_trend_title => 'Last 7 days';

  @override
  String get history_trend_caloriesLegend => 'Calories';

  @override
  String get history_trend_goalLegend => 'Goal';

  @override
  String get meal_delete_confirm => 'Delete this meal? This cannot be undone.';

  @override
  String get meal_delete_success => 'Meal deleted';

  @override
  String get goal_field_kcal => 'Daily goal (kcal)';

  @override
  String get goal_sex_label => 'Sex';

  @override
  String get goal_sex_male => 'Male';

  @override
  String get goal_sex_female => 'Female';

  @override
  String get goal_field_age => 'Age';

  @override
  String get goal_activity_sedentary => 'Sedentary';

  @override
  String get goal_activity_light => 'Light';

  @override
  String get goal_activity_moderate => 'Moderate';

  @override
  String get goal_activity_active => 'Active';

  @override
  String get goal_activity_veryActive => 'Very active';

  @override
  String get goal_type_label => 'Goal';

  @override
  String get goal_type_lose => 'Lose';

  @override
  String get goal_type_maintain => 'Maintain';

  @override
  String get goal_type_gain => 'Gain';

  @override
  String goal_estimate_result(int kcal) {
    return 'Suggested: $kcal kcal';
  }

  @override
  String get goal_estimate_apply => 'Use this value';

  @override
  String get goal_save_success => 'Goal saved';

  @override
  String get settings_units_energy => 'Energy';

  @override
  String get settings_units_mass => 'Mass';

  @override
  String get settings_units_kcal => 'kcal';

  @override
  String get settings_units_kj => 'kJ';

  @override
  String get settings_units_g => 'grams';

  @override
  String get settings_units_oz => 'ounces';

  @override
  String get settings_account_section => 'Account';

  @override
  String get settings_dangerZone => 'Danger zone';

  @override
  String get account_delete_cancel => 'Cancel';

  @override
  String get logout_confirm => 'Log out of your account?';
}
