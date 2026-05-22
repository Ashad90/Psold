import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Psold'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Products on Sale'**
  String get tagline;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginEmail;

  /// No description provided for @loginPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get loginPhone;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get loginWithEmail;

  /// No description provided for @loginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone'**
  String get loginWithPhone;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @roleClient.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleClient;

  /// No description provided for @roleMerchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get roleMerchant;

  /// No description provided for @roleCardMerchantTitle.
  ///
  /// In en, this message translates to:
  /// **'Merchant Account'**
  String get roleCardMerchantTitle;

  /// No description provided for @roleCardMerchantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I sell products\non sale or near expiry'**
  String get roleCardMerchantSubtitle;

  /// No description provided for @roleCardClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Account'**
  String get roleCardClientTitle;

  /// No description provided for @roleCardClientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for good deals\non products on sale'**
  String get roleCardClientSubtitle;

  /// No description provided for @merchantUploadFeatures.
  ///
  /// In en, this message translates to:
  /// **'Photo & video uploads,AI automatic validation,Statistics dashboard,Buyer visibility'**
  String get merchantUploadFeatures;

  /// No description provided for @clientFeatures.
  ///
  /// In en, this message translates to:
  /// **'Browse products near me,Like and comment posts,Contact seller via WhatsApp,New offer notifications'**
  String get clientFeatures;

  /// No description provided for @onboardingWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number'**
  String get onboardingWhatsapp;

  /// No description provided for @onboardingCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get onboardingCity;

  /// No description provided for @registerMerchantTitle.
  ///
  /// In en, this message translates to:
  /// **'Merchant Registration'**
  String get registerMerchantTitle;

  /// No description provided for @registerClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Registration'**
  String get registerClientTitle;

  /// No description provided for @registerShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name *'**
  String get registerShopName;

  /// No description provided for @registerDisplayName.
  ///
  /// In en, this message translates to:
  /// **'First name or nickname *'**
  String get registerDisplayName;

  /// No description provided for @registerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get registerEmail;

  /// No description provided for @registerWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number *'**
  String get registerWhatsApp;

  /// No description provided for @registerCity.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get registerCity;

  /// No description provided for @registerCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get registerCreateAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginLink;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Products on Sale'**
  String get feedTitle;

  /// No description provided for @feedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get feedEmpty;

  /// No description provided for @feedError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get feedError;

  /// No description provided for @feedRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get feedRetry;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get filterSortBy;

  /// No description provided for @filterExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get filterExpiry;

  /// No description provided for @filterPopularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get filterPopularity;

  /// No description provided for @filterRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius (km)'**
  String get filterRadius;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get filterDistance;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryCosmetique.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get categoryCosmetique;

  /// No description provided for @categoryElectro.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get categoryElectro;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @discuss.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get discuss;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @likeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String likeCount(int count);

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @uploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Post a product'**
  String get uploadTitle;

  /// No description provided for @uploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Product photos'**
  String get uploadPhotos;

  /// No description provided for @uploadCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get uploadCamera;

  /// No description provided for @uploadGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get uploadGallery;

  /// No description provided for @uploadProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Product title *'**
  String get uploadProductTitle;

  /// No description provided for @uploadDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get uploadDescription;

  /// No description provided for @uploadCategory.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get uploadCategory;

  /// No description provided for @uploadOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original price (CFA)'**
  String get uploadOriginalPrice;

  /// No description provided for @uploadPromoPrice.
  ///
  /// In en, this message translates to:
  /// **'Promo price * (CFA)'**
  String get uploadPromoPrice;

  /// No description provided for @uploadExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date *'**
  String get uploadExpiryDate;

  /// No description provided for @uploadQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity *'**
  String get uploadQuantity;

  /// No description provided for @uploadCity.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get uploadCity;

  /// No description provided for @uploadValidate.
  ///
  /// In en, this message translates to:
  /// **'Validate & publish'**
  String get uploadValidate;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product published successfully!'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Product refused: {reason}'**
  String uploadFailed(String reason);

  /// No description provided for @uploadRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get uploadRequired;

  /// No description provided for @uploadAddImage.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one image'**
  String get uploadAddImage;

  /// No description provided for @uploadVideo.
  ///
  /// In en, this message translates to:
  /// **'Product video (optional)'**
  String get uploadVideo;

  /// No description provided for @uploadAddVideo.
  ///
  /// In en, this message translates to:
  /// **'Add a video'**
  String get uploadAddVideo;

  /// No description provided for @uploadTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Yogurt expiring soon'**
  String get uploadTitleHint;

  /// No description provided for @uploadDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Additional description...'**
  String get uploadDescriptionHint;

  /// No description provided for @uploadSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get uploadSelectDate;

  /// No description provided for @uploadCityHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Bangui'**
  String get uploadCityHint;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 5'**
  String get quantityHint;

  /// No description provided for @uploadNotConnected.
  ///
  /// In en, this message translates to:
  /// **'User not connected'**
  String get uploadNotConnected;

  /// No description provided for @uploadImageError.
  ///
  /// In en, this message translates to:
  /// **'Error uploading images'**
  String get uploadImageError;

  /// No description provided for @uploadAIError.
  ///
  /// In en, this message translates to:
  /// **'AI validation error'**
  String get uploadAIError;

  /// No description provided for @uploadPickError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting images'**
  String get uploadPickError;

  /// No description provided for @uploadCameraError.
  ///
  /// In en, this message translates to:
  /// **'Error capturing image'**
  String get uploadCameraError;

  /// No description provided for @uploadVideoError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting video'**
  String get uploadVideoError;

  /// No description provided for @uploadNotValidated.
  ///
  /// In en, this message translates to:
  /// **'Product not validated'**
  String get uploadNotValidated;

  /// No description provided for @uploadOcrPrompt.
  ///
  /// In en, this message translates to:
  /// **'Date not detected — please enter it manually'**
  String get uploadOcrPrompt;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @validationPending.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validationPending;

  /// No description provided for @validationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product published successfully'**
  String get validationSuccess;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Publication refused: {reason}'**
  String validationFailed(String reason);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(int days);

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) left'**
  String daysRemaining(int days);

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String quantity(int count);

  /// No description provided for @merchantDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Dashboard'**
  String get merchantDashboard;

  /// No description provided for @merchantProducts.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get merchantProducts;

  /// No description provided for @merchantStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get merchantStats;

  /// No description provided for @productsActive.
  ///
  /// In en, this message translates to:
  /// **'Active products'**
  String get productsActive;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @expiredProducts.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiredProducts;

  /// No description provided for @publishProduct.
  ///
  /// In en, this message translates to:
  /// **'Post a product'**
  String get publishProduct;

  /// No description provided for @manageProducts.
  ///
  /// In en, this message translates to:
  /// **'Manage my posts'**
  String get manageProducts;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products posted'**
  String get noProducts;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for a product...'**
  String get searchPlaceholder;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get searchEmpty;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsLogout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @begin.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get begin;

  /// No description provided for @dailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached'**
  String get dailyLimitReached;

  /// No description provided for @dailyLimitFormat.
  ///
  /// In en, this message translates to:
  /// **'{images}/{imageLimit} images · {videos}/{videoLimit} videos today'**
  String dailyLimitFormat(int images, int imageLimit, int videos, int videoLimit);

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumTitle;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to post without limits.'**
  String get premiumDescription;

  /// No description provided for @premiumCTA.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumCTA;

  /// No description provided for @dailyLimitFreeTier.
  ///
  /// In en, this message translates to:
  /// **'5 images · 2 videos per day'**
  String get dailyLimitFreeTier;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActive;

  /// No description provided for @premiumUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited uploads'**
  String get premiumUnlimited;

  /// No description provided for @premiumLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit reached'**
  String get premiumLimitReached;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support to activate Premium.'**
  String get contactSupport;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
