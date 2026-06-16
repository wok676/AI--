// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

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
}
