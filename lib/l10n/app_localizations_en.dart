// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Psold';

  @override
  String get tagline => 'Products on Sale';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginEmail => 'Email address';

  @override
  String get loginPhone => 'Phone number';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginWithEmail => 'Sign in with email';

  @override
  String get loginWithPhone => 'Sign in with phone';

  @override
  String get registerTitle => 'Create account';

  @override
  String get roleClient => 'Customer';

  @override
  String get roleMerchant => 'Merchant';

  @override
  String get roleCardMerchantTitle => 'Merchant Account';

  @override
  String get roleCardMerchantSubtitle => 'I sell products\non sale or near expiry';

  @override
  String get roleCardClientTitle => 'Customer Account';

  @override
  String get roleCardClientSubtitle => 'I\'m looking for good deals\non products on sale';

  @override
  String get merchantUploadFeatures => 'Photo & video uploads,AI automatic validation,Statistics dashboard,Buyer visibility';

  @override
  String get clientFeatures => 'Browse products near me,Like and comment posts,Contact seller via WhatsApp,New offer notifications';

  @override
  String get onboardingWhatsapp => 'WhatsApp number';

  @override
  String get onboardingCity => 'City';

  @override
  String get registerMerchantTitle => 'Merchant Registration';

  @override
  String get registerClientTitle => 'Customer Registration';

  @override
  String get registerShopName => 'Shop name *';

  @override
  String get registerDisplayName => 'First name or nickname *';

  @override
  String get registerEmail => 'Email *';

  @override
  String get registerWhatsApp => 'WhatsApp number *';

  @override
  String get registerCity => 'City *';

  @override
  String get registerCreateAccount => 'Create my account';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Sign in';

  @override
  String get feedTitle => 'Products on Sale';

  @override
  String get feedEmpty => 'No products available';

  @override
  String get feedError => 'Error';

  @override
  String get feedRetry => 'Retry';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterSortBy => 'Sort by';

  @override
  String get filterExpiry => 'Expiry date';

  @override
  String get filterPopularity => 'Popularity';

  @override
  String get filterRadius => 'Radius (km)';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterDistance => 'Distance';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryCosmetique => 'Cosmetics';

  @override
  String get categoryElectro => 'Electronics';

  @override
  String get categoryOther => 'Other';

  @override
  String get contact => 'Contact';

  @override
  String get discuss => 'Chat';

  @override
  String get like => 'Like';

  @override
  String likeCount(int count) {
    return '$count likes';
  }

  @override
  String get comment => 'Comment';

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get uploadTitle => 'Post a product';

  @override
  String get uploadPhotos => 'Product photos';

  @override
  String get uploadCamera => 'Camera';

  @override
  String get uploadGallery => 'Gallery';

  @override
  String get uploadProductTitle => 'Product title *';

  @override
  String get uploadDescription => 'Description (optional)';

  @override
  String get uploadCategory => 'Category *';

  @override
  String get uploadOriginalPrice => 'Original price (CFA)';

  @override
  String get uploadPromoPrice => 'Promo price * (CFA)';

  @override
  String get uploadExpiryDate => 'Expiry date *';

  @override
  String get uploadQuantity => 'Quantity *';

  @override
  String get uploadCity => 'City (optional)';

  @override
  String get uploadValidate => 'Validate & publish';

  @override
  String get uploadSuccess => 'Product published successfully!';

  @override
  String uploadFailed(String reason) {
    return 'Product refused: $reason';
  }

  @override
  String get uploadRequired => 'Please fill all required fields';

  @override
  String get uploadAddImage => 'Please add at least one image';

  @override
  String get uploadVideo => 'Product video (optional)';

  @override
  String get uploadAddVideo => 'Add a video';

  @override
  String get uploadTitleHint => 'E.g.: Yogurt expiring soon';

  @override
  String get uploadDescriptionHint => 'Additional description...';

  @override
  String get uploadSelectDate => 'Select a date';

  @override
  String get uploadCityHint => 'E.g.: Bangui';

  @override
  String get quantityHint => 'E.g.: 5';

  @override
  String get uploadNotConnected => 'User not connected';

  @override
  String get uploadImageError => 'Error uploading images';

  @override
  String get uploadAIError => 'AI validation error';

  @override
  String get uploadPickError => 'Error selecting images';

  @override
  String get uploadCameraError => 'Error capturing image';

  @override
  String get uploadVideoError => 'Error selecting video';

  @override
  String get uploadNotValidated => 'Product not validated';

  @override
  String get uploadOcrPrompt => 'Date not detected — please enter it manually';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get validationPending => 'Validating...';

  @override
  String get validationSuccess => 'Product published successfully';

  @override
  String validationFailed(String reason) {
    return 'Publication refused: $reason';
  }

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String daysRemaining(int days) {
    return '$days day(s) left';
  }

  @override
  String get expired => 'Expired';

  @override
  String quantity(int count) {
    return 'Qty: $count';
  }

  @override
  String get merchantDashboard => 'My Dashboard';

  @override
  String get merchantProducts => 'My Products';

  @override
  String get merchantStats => 'Statistics';

  @override
  String get productsActive => 'Active products';

  @override
  String get views => 'Views';

  @override
  String get likes => 'Likes';

  @override
  String get expiredProducts => 'Expired';

  @override
  String get publishProduct => 'Post a product';

  @override
  String get manageProducts => 'Manage my posts';

  @override
  String get noProducts => 'No products posted';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search for a product...';

  @override
  String get searchEmpty => 'Type to search';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get profile => 'My Profile';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get logout => 'Sign out';

  @override
  String get back => 'Back';

  @override
  String get begin => 'Get Started';

  @override
  String get dailyLimitReached => 'Daily limit reached';

  @override
  String dailyLimitFormat(int images, int imageLimit, int videos, int videoLimit) {
    return '$images/$imageLimit images · $videos/$videoLimit videos today';
  }

  @override
  String get premiumTitle => 'Go Premium';

  @override
  String get premiumDescription => 'Upgrade to Premium to post without limits.';

  @override
  String get premiumCTA => 'Go Premium';

  @override
  String get dailyLimitFreeTier => '5 images · 2 videos per day';

  @override
  String get goPremium => 'Go Premium';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get premiumUnlimited => 'Unlimited uploads';

  @override
  String get premiumLimitReached => 'Limit reached';

  @override
  String get contactSupport => 'Contact support to activate Premium.';

  @override
  String get later => 'Later';
}
