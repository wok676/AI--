import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// App display name
  ///
  /// In en, this message translates to:
  /// **'Calorie Tracker'**
  String get appTitle;

  /// Login screen value proposition (UI §5.1)
  ///
  /// In en, this message translates to:
  /// **'Snap your meal. Know your calories.'**
  String get brandTagline;

  /// No description provided for @common_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get common_loading;

  /// No description provided for @common_empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get common_empty;

  /// No description provided for @common_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get common_error_generic;

  /// No description provided for @common_error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get common_error_network;

  /// No description provided for @common_error_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get common_error_timeout;

  /// No description provided for @errors_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please log in again'**
  String get errors_unauthorized;

  /// No description provided for @errors_forbidden.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to perform this action'**
  String get errors_forbidden;

  /// No description provided for @errors_notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errors_notFound;

  /// No description provided for @auth_signup_title.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signup_title;

  /// No description provided for @auth_login_title.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get auth_login_title;

  /// No description provided for @auth_field_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_field_email;

  /// No description provided for @auth_field_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_field_password;

  /// No description provided for @auth_password_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak password. Use letters and numbers.'**
  String get auth_password_weak;

  /// No description provided for @auth_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get auth_email_invalid;

  /// No description provided for @auth_consent_label.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Service and Privacy Policy'**
  String get auth_consent_label;

  /// No description provided for @auth_consent_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get auth_consent_terms;

  /// No description provided for @auth_consent_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get auth_consent_privacy;

  /// No description provided for @auth_consent_required.
  ///
  /// In en, this message translates to:
  /// **'Please read and accept the Terms and Privacy Policy first'**
  String get auth_consent_required;

  /// No description provided for @auth_apple_signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get auth_apple_signin;

  /// No description provided for @auth_google_signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get auth_google_signin;

  /// No description provided for @auth_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get auth_logout;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get auth_forgotPassword;

  /// No description provided for @auth_error_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get auth_error_invalidCredentials;

  /// No description provided for @capture_method_photo.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get capture_method_photo;

  /// No description provided for @capture_method_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get capture_method_gallery;

  /// No description provided for @capture_method_text.
  ///
  /// In en, this message translates to:
  /// **'Describe in text'**
  String get capture_method_text;

  /// No description provided for @capture_text_placeholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. a bowl of beef noodles + a fried egg'**
  String get capture_text_placeholder;

  /// No description provided for @capture_cta_recognize.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get capture_cta_recognize;

  /// No description provided for @recognize_loading.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your food…'**
  String get recognize_loading;

  /// No description provided for @recognize_result_title.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get recognize_result_title;

  /// No description provided for @recognize_item_calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get recognize_item_calories;

  /// No description provided for @recognize_item_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get recognize_item_protein;

  /// No description provided for @recognize_item_carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get recognize_item_carbs;

  /// No description provided for @recognize_item_fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get recognize_item_fat;

  /// No description provided for @recognize_item_serving.
  ///
  /// In en, this message translates to:
  /// **'Serving'**
  String get recognize_item_serving;

  /// No description provided for @recognize_item_addManual.
  ///
  /// In en, this message translates to:
  /// **'Add item manually'**
  String get recognize_item_addManual;

  /// No description provided for @recognize_lowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence — please double-check'**
  String get recognize_lowConfidence;

  /// No description provided for @recognize_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Calorie and nutrition figures are AI estimates and may be inaccurate. For reference only; not medical or health advice.'**
  String get recognize_disclaimer;

  /// No description provided for @recognize_error_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t recognize this image. Try another photo or add manually.'**
  String get recognize_error_failed;

  /// No description provided for @recognize_limit_reached.
  ///
  /// In en, this message translates to:
  /// **'Daily recognition limit reached. Please try again tomorrow.'**
  String get recognize_limit_reached;

  /// No description provided for @meal_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get meal_breakfast;

  /// No description provided for @meal_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get meal_lunch;

  /// No description provided for @meal_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get meal_dinner;

  /// No description provided for @meal_snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get meal_snack;

  /// No description provided for @home_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get home_today;

  /// Consecutive logging days (UI §5.2)
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String home_streak(int count);

  /// No description provided for @home_empty_cta.
  ///
  /// In en, this message translates to:
  /// **'Log your first meal'**
  String get home_empty_cta;

  /// No description provided for @home_fab_addMeal.
  ///
  /// In en, this message translates to:
  /// **'Log a meal'**
  String get home_fab_addMeal;

  /// No description provided for @summary_consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get summary_consumed;

  /// No description provided for @summary_goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get summary_goal;

  /// Remaining calories for the day
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal left'**
  String summary_remaining(int kcal);

  /// History screen AppBar title & bottom nav tab (UI §4.1/§5.5)
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history_title;

  /// No description provided for @history_tab_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get history_tab_day;

  /// No description provided for @history_tab_trend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get history_tab_trend;

  /// No description provided for @goal_title.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie goal'**
  String get goal_title;

  /// No description provided for @goal_estimate_cta.
  ///
  /// In en, this message translates to:
  /// **'Estimate for me'**
  String get goal_estimate_cta;

  /// No description provided for @goal_field_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get goal_field_height;

  /// No description provided for @goal_field_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get goal_field_weight;

  /// No description provided for @goal_field_activity.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get goal_field_activity;

  /// No description provided for @goal_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimate is for reference only, adjustable, and not medical advice.'**
  String get goal_disclaimer;

  /// No description provided for @perm_camera_title.
  ///
  /// In en, this message translates to:
  /// **'Camera access'**
  String get perm_camera_title;

  /// No description provided for @perm_camera_body.
  ///
  /// In en, this message translates to:
  /// **'To take photos of your food for AI analysis. Used only when you take a photo.'**
  String get perm_camera_body;

  /// No description provided for @perm_photos_title.
  ///
  /// In en, this message translates to:
  /// **'Photo access'**
  String get perm_photos_title;

  /// No description provided for @perm_photos_body.
  ///
  /// In en, this message translates to:
  /// **'To pick a food photo for analysis. Only the photo you select is read.'**
  String get perm_photos_body;

  /// No description provided for @perm_notify_title.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get perm_notify_title;

  /// No description provided for @perm_notify_body.
  ///
  /// In en, this message translates to:
  /// **'Helps you build a logging habit. You can turn it off anytime.'**
  String get perm_notify_body;

  /// No description provided for @perm_allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get perm_allow;

  /// No description provided for @perm_notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get perm_notNow;

  /// No description provided for @perm_openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get perm_openSettings;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settings_units;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settings_profile;

  /// No description provided for @settings_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settings_terms;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_language_title.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get settings_language_title;

  /// No description provided for @settings_language_systemDefault.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settings_language_systemDefault;

  /// No description provided for @account_delete_entry.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get account_delete_entry;

  /// No description provided for @account_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get account_delete_title;

  /// No description provided for @account_delete_warning.
  ///
  /// In en, this message translates to:
  /// **'Once deleted, your meal logs, photos, profile, and goals are permanently and irreversibly erased and cannot be recovered.'**
  String get account_delete_warning;

  /// No description provided for @account_delete_confirmHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get account_delete_confirmHint;

  /// No description provided for @account_delete_confirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get account_delete_confirmBtn;

  /// No description provided for @account_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Your account and data have been permanently deleted'**
  String get account_delete_success;

  /// No description provided for @account_delete_web.
  ///
  /// In en, this message translates to:
  /// **'You can also delete your account on the web'**
  String get account_delete_web;

  /// No description provided for @privacy_photo_retention.
  ///
  /// In en, this message translates to:
  /// **'Your food photos are used only for instant AI analysis. Original images are not retained long-term; we keep only the recognized result data.'**
  String get privacy_photo_retention;

  /// No description provided for @auth_signup_switchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get auth_signup_switchToLogin;

  /// No description provided for @auth_login_switchToSignup.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Sign up'**
  String get auth_login_switchToSignup;

  /// No description provided for @auth_field_emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get auth_field_emailHint;

  /// No description provided for @auth_orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get auth_orDivider;

  /// No description provided for @today_dateStreakSeparator.
  ///
  /// In en, this message translates to:
  /// **'·'**
  String get today_dateStreakSeparator;

  /// No description provided for @summary_unit_kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get summary_unit_kcal;

  /// No description provided for @summary_goalNotSet.
  ///
  /// In en, this message translates to:
  /// **'No goal set yet'**
  String get summary_goalNotSet;

  /// No description provided for @today_mealNotLogged.
  ///
  /// In en, this message translates to:
  /// **'Not logged'**
  String get today_mealNotLogged;

  /// No description provided for @today_mealItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String today_mealItemCount(int count);

  /// No description provided for @capture_title.
  ///
  /// In en, this message translates to:
  /// **'Log a meal'**
  String get capture_title;

  /// No description provided for @capture_text_title.
  ///
  /// In en, this message translates to:
  /// **'Describe your meal'**
  String get capture_text_title;

  /// No description provided for @capture_camera_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera is unavailable on this device. Try the gallery or text instead.'**
  String get capture_camera_unavailable;

  /// No description provided for @capture_gallery_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No photo selected.'**
  String get capture_gallery_unavailable;

  /// No description provided for @recognize_item_serving_unit_serving.
  ///
  /// In en, this message translates to:
  /// **'serving'**
  String get recognize_item_serving_unit_serving;

  /// No description provided for @recognize_item_serving_unit_piece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get recognize_item_serving_unit_piece;

  /// No description provided for @recognize_item_serving_unit_gram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get recognize_item_serving_unit_gram;

  /// No description provided for @recognize_editItem_title.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get recognize_editItem_title;

  /// No description provided for @recognize_field_name.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get recognize_field_name;

  /// No description provided for @recognize_field_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get recognize_field_quantity;

  /// No description provided for @recognize_field_unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get recognize_field_unit;

  /// No description provided for @recognize_mealType_label.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get recognize_mealType_label;

  /// No description provided for @recognize_save_success.
  ///
  /// In en, this message translates to:
  /// **'Meal saved'**
  String get recognize_save_success;

  /// No description provided for @recognize_emptyItems.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item before saving'**
  String get recognize_emptyItems;

  /// No description provided for @history_prevDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get history_prevDay;

  /// No description provided for @history_nextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get history_nextDay;

  /// No description provided for @history_trend_title.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get history_trend_title;

  /// No description provided for @history_trend_caloriesLegend.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get history_trend_caloriesLegend;

  /// No description provided for @history_trend_goalLegend.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get history_trend_goalLegend;

  /// No description provided for @meal_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this meal? This cannot be undone.'**
  String get meal_delete_confirm;

  /// No description provided for @meal_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Meal deleted'**
  String get meal_delete_success;

  /// No description provided for @goal_field_kcal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal (kcal)'**
  String get goal_field_kcal;

  /// No description provided for @goal_sex_label.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get goal_sex_label;

  /// No description provided for @goal_sex_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get goal_sex_male;

  /// No description provided for @goal_sex_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get goal_sex_female;

  /// No description provided for @goal_field_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get goal_field_age;

  /// No description provided for @goal_activity_sedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get goal_activity_sedentary;

  /// No description provided for @goal_activity_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get goal_activity_light;

  /// No description provided for @goal_activity_moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get goal_activity_moderate;

  /// No description provided for @goal_activity_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get goal_activity_active;

  /// No description provided for @goal_activity_veryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get goal_activity_veryActive;

  /// No description provided for @goal_type_label.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal_type_label;

  /// No description provided for @goal_type_lose.
  ///
  /// In en, this message translates to:
  /// **'Lose'**
  String get goal_type_lose;

  /// No description provided for @goal_type_maintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get goal_type_maintain;

  /// No description provided for @goal_type_gain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get goal_type_gain;

  /// No description provided for @goal_estimate_result.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {kcal} kcal'**
  String goal_estimate_result(int kcal);

  /// No description provided for @goal_estimate_apply.
  ///
  /// In en, this message translates to:
  /// **'Use this value'**
  String get goal_estimate_apply;

  /// No description provided for @goal_save_success.
  ///
  /// In en, this message translates to:
  /// **'Goal saved'**
  String get goal_save_success;

  /// No description provided for @settings_units_energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get settings_units_energy;

  /// No description provided for @settings_units_mass.
  ///
  /// In en, this message translates to:
  /// **'Mass'**
  String get settings_units_mass;

  /// No description provided for @settings_units_kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get settings_units_kcal;

  /// No description provided for @settings_units_kj.
  ///
  /// In en, this message translates to:
  /// **'kJ'**
  String get settings_units_kj;

  /// No description provided for @settings_units_g.
  ///
  /// In en, this message translates to:
  /// **'grams'**
  String get settings_units_g;

  /// No description provided for @settings_units_oz.
  ///
  /// In en, this message translates to:
  /// **'ounces'**
  String get settings_units_oz;

  /// No description provided for @settings_account_section.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account_section;

  /// No description provided for @settings_dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settings_dangerZone;

  /// No description provided for @account_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get account_delete_cancel;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account?'**
  String get logout_confirm;

  /// Banner shown atop in-app Terms/Privacy stating the copy is placeholder and the public URL is pending deployment
  ///
  /// In en, this message translates to:
  /// **'Draft for in-app review. This is a placeholder version: the final legal text will be provided by Product/Operations, and an official public URL will be published after deployment.'**
  String get legal_draftNotice;

  /// No description provided for @legal_lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: 2026-06-17 (draft)'**
  String get legal_lastUpdated;

  /// No description provided for @legal_contact_h.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get legal_contact_h;

  /// No description provided for @legal_contact_b.
  ///
  /// In en, this message translates to:
  /// **'Questions about these terms or your data? Contact us at support@example.com (placeholder; final contact details pending). We aim to respond within a reasonable time.'**
  String get legal_contact_b;

  /// No description provided for @legal_terms_title.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get legal_terms_title;

  /// No description provided for @legal_terms_s1_h.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get legal_terms_s1_h;

  /// No description provided for @legal_terms_s1_b.
  ///
  /// In en, this message translates to:
  /// **'By creating an account or using Calorie Tracker (the \"App\"), you agree to these Terms of Service. If you do not agree, please do not use the App. You must be old enough to consent to data processing in your jurisdiction.'**
  String get legal_terms_s1_b;

  /// No description provided for @legal_terms_s2_h.
  ///
  /// In en, this message translates to:
  /// **'2. The Service'**
  String get legal_terms_s2_h;

  /// No description provided for @legal_terms_s2_b.
  ///
  /// In en, this message translates to:
  /// **'The App lets you log meals via photo, gallery image, or text, and uses AI to estimate calories and macronutrients (protein, carbohydrates, fat). All AI estimates are approximations for general informational purposes only.'**
  String get legal_terms_s2_b;

  /// No description provided for @legal_terms_s3_h.
  ///
  /// In en, this message translates to:
  /// **'3. AI Estimate Disclaimer'**
  String get legal_terms_s3_h;

  /// No description provided for @legal_terms_s3_b.
  ///
  /// In en, this message translates to:
  /// **'Calorie and nutrient figures are automatically estimated and may be inaccurate. They are NOT medical, dietary, or health advice and must not be used for diagnosis or treatment. Always verify important values and consult a qualified professional for medical or nutritional decisions. You remain in control of and responsible for the data you save.'**
  String get legal_terms_s3_b;

  /// No description provided for @legal_terms_s4_h.
  ///
  /// In en, this message translates to:
  /// **'4. Your Responsibilities'**
  String get legal_terms_s4_h;

  /// No description provided for @legal_terms_s4_b.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for keeping your credentials secure, for the accuracy of information you enter, and for using the App lawfully. Do not misuse the App, attempt unauthorized access, or upload unlawful content.'**
  String get legal_terms_s4_b;

  /// No description provided for @legal_terms_s5_h.
  ///
  /// In en, this message translates to:
  /// **'5. Account Deletion'**
  String get legal_terms_s5_h;

  /// No description provided for @legal_terms_s5_b.
  ///
  /// In en, this message translates to:
  /// **'You may delete your account at any time from Settings. Deletion is irreversible and permanently removes your meal logs, goals, and profile from our active systems, subject to limited retention required by law. See the Privacy Policy for details.'**
  String get legal_terms_s5_b;

  /// No description provided for @legal_terms_s6_h.
  ///
  /// In en, this message translates to:
  /// **'6. Changes & Limitation of Liability'**
  String get legal_terms_s6_h;

  /// No description provided for @legal_terms_s6_b.
  ///
  /// In en, this message translates to:
  /// **'We may update the App and these Terms; material changes will be communicated in-app. To the extent permitted by law, the App is provided \"as is\" without warranties, and we are not liable for decisions made based on AI estimates.'**
  String get legal_terms_s6_b;

  /// No description provided for @legal_privacy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legal_privacy_title;

  /// No description provided for @legal_privacy_s1_h.
  ///
  /// In en, this message translates to:
  /// **'1. Data We Collect'**
  String get legal_privacy_s1_h;

  /// No description provided for @legal_privacy_s1_b.
  ///
  /// In en, this message translates to:
  /// **'We collect: account data (email, or Apple ID identifier if you use Sign in with Apple); content you create (meal entries, food names, portions, calorie/macro values, optional thumbnails); preferences (language, units, daily goal, notification setting); and limited technical data needed to operate the service.'**
  String get legal_privacy_s1_b;

  /// No description provided for @legal_privacy_s2_h.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Data'**
  String get legal_privacy_s2_h;

  /// No description provided for @legal_privacy_s2_b.
  ///
  /// In en, this message translates to:
  /// **'We use your data to provide core features (logging meals, generating AI calorie/macro estimates, tracking history and goals), to authenticate you, to remember your preferences, and to secure and improve the service. We do not sell your personal data.'**
  String get legal_privacy_s2_b;

  /// No description provided for @legal_privacy_s3_h.
  ///
  /// In en, this message translates to:
  /// **'3. Third-Party Services & Consent'**
  String get legal_privacy_s3_h;

  /// No description provided for @legal_privacy_s3_b.
  ///
  /// In en, this message translates to:
  /// **'Photo/text content may be processed by an AI recognition provider solely to return an estimate. Any optional analytics or push services remain disabled until you actively consent to this Policy; we do not initialize non-essential third-party SDKs before consent. Permissions (camera, photos, notifications) are requested only when you use the related feature.'**
  String get legal_privacy_s3_b;

  /// No description provided for @legal_privacy_s4_h.
  ///
  /// In en, this message translates to:
  /// **'4. Storage & Security'**
  String get legal_privacy_s4_h;

  /// No description provided for @legal_privacy_s4_b.
  ///
  /// In en, this message translates to:
  /// **'Data is stored on secured servers and transmitted over encrypted (HTTPS) connections. Authentication tokens are kept in the device\'s secure storage. We apply access controls and retain data only as long as your account is active or as required by law.'**
  String get legal_privacy_s4_b;

  /// No description provided for @legal_privacy_s5_h.
  ///
  /// In en, this message translates to:
  /// **'5. Account & Data Deletion'**
  String get legal_privacy_s5_h;

  /// No description provided for @legal_privacy_s5_b.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account (Settings > Delete account, with confirmation) permanently and irreversibly removes your profile, meal logs, and goals from our active systems, and clears all credentials stored on your device. A web-based deletion channel is also available where required.'**
  String get legal_privacy_s5_b;

  /// No description provided for @legal_privacy_s6_h.
  ///
  /// In en, this message translates to:
  /// **'6. Your Rights'**
  String get legal_privacy_s6_h;

  /// No description provided for @legal_privacy_s6_b.
  ///
  /// In en, this message translates to:
  /// **'Subject to your local laws, you may access, correct, export, or delete your data. To exercise these rights, use the in-app controls or contact us. We will respond consistent with applicable data-protection law.'**
  String get legal_privacy_s6_b;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'ko',
    'pt',
    'ru',
    'ur',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
