// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Psold';

  @override
  String get tagline => 'المنتجات المخفضة';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginEmail => 'البريد الإلكتروني';

  @override
  String get loginPhone => 'رقم الهاتف';

  @override
  String get loginButton => 'دخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get roleClient => 'عميل';

  @override
  String get roleMerchant => 'تاجر';

  @override
  String get onboardingWhatsapp => 'رقم واتساب';

  @override
  String get onboardingCity => 'المدينة';

  @override
  String get feedTitle => 'المنتجات المخفضة';

  @override
  String get filterCategory => 'الفئة';

  @override
  String get filterDistance => 'المسافة';

  @override
  String get categoryFood => 'غذائي';

  @override
  String get categoryElectro => 'إلكترونيات';

  @override
  String get categoryCosmetique => 'مستحضرات تجميل';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get contact => 'تواصل';

  @override
  String get like => 'إعجاب';

  @override
  String get comment => 'تعليق';

  @override
  String get uploadTitle => 'نشر منتج';

  @override
  String get uploadExpiryDate => 'تاريخ انتهاء الصلاحية';

  @override
  String get uploadPrice => 'سعر التخفيض';

  @override
  String get uploadOriginalPrice => 'السعر الأصلي';

  @override
  String get uploadQuantity => 'الكمية';

  @override
  String get uploadValidate => 'تحقق ونشر';

  @override
  String get validationPending => 'جارٍ التحقق…';

  @override
  String get validationSuccess => 'تم نشر المنتج بنجاح';

  @override
  String validationFailed(String reason) {
    return 'رُفض النشر: $reason';
  }

  @override
  String daysLeft(int days) {
    return '$days أيام متبقية';
  }

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeSystem => 'النظام';

  @override
  String get errorGeneric => 'حدث خطأ';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get logout => 'تسجيل الخروج';
}
