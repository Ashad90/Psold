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
  String get registerTitle => 'Create account';

  @override
  String get roleClient => 'Customer';

  @override
  String get roleMerchant => 'Merchant';

  @override
  String get onboardingWhatsapp => 'WhatsApp number';

  @override
  String get onboardingCity => 'City';

  @override
  String get feedTitle => 'Products on Sale';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterDistance => 'Distance';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryElectro => 'Electronics';

  @override
  String get categoryCosmetique => 'Cosmetics';

  @override
  String get categoryOther => 'Other';

  @override
  String get contact => 'Contact';

  @override
  String get like => 'Like';

  @override
  String get comment => 'Comment';

  @override
  String get uploadTitle => 'Post a product';

  @override
  String get uploadExpiryDate => 'Expiry date';

  @override
  String get uploadPrice => 'Sale price';

  @override
  String get uploadOriginalPrice => 'Original price';

  @override
  String get uploadQuantity => 'Quantity';

  @override
  String get uploadValidate => 'Validate & publish';

  @override
  String get validationPending => 'Validating…';

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
  String get errorGeneric => 'An error occurred';

  @override
  String get retry => 'Try again';

  @override
  String get logout => 'Sign out';
}
