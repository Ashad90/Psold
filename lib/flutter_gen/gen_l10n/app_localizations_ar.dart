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
  String get loginWithEmail => 'الدخول بالبريد';

  @override
  String get loginWithPhone => 'الدخول بالهاتف';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get roleClient => 'عميل';

  @override
  String get roleMerchant => 'تاجر';

  @override
  String get roleCardMerchantTitle => 'حساب التاجر';

  @override
  String get roleCardMerchantSubtitle =>
      'أبيع منتجات\nمخفضة أو قريبة من انتهاء الصلاحية';

  @override
  String get roleCardClientTitle => 'حساب العميل';

  @override
  String get roleCardClientSubtitle => 'أبحث عن عروض\nمنتجات مخفضة';

  @override
  String get merchantUploadFeatures =>
      'رفع صور وفيديو,التحقق بالذكاء الاصطناعي,لوحة إحصائيات,الظهور للمشترين';

  @override
  String get clientFeatures =>
      'تصفح المنتجات القريبة,إعجاب وتعليق,التواصل عبر واتساب,إشعارات العروض الجديدة';

  @override
  String get onboardingWhatsapp => 'رقم واتساب';

  @override
  String get onboardingCity => 'المدينة';

  @override
  String get registerMerchantTitle => 'تسجيل التاجر';

  @override
  String get registerClientTitle => 'تسجيل العميل';

  @override
  String get registerShopName => 'اسم المحل *';

  @override
  String get registerDisplayName => 'الاسم أو اللقب *';

  @override
  String get registerEmail => 'البريد الإلكتروني *';

  @override
  String get registerWhatsApp => 'رقم واتساب *';

  @override
  String get registerCity => 'المدينة *';

  @override
  String get registerCreateAccount => 'إنشاء حسابي';

  @override
  String get alreadyHaveAccount => 'لديك حساب؟ ';

  @override
  String get loginLink => 'تسجيل الدخول';

  @override
  String get feedTitle => 'المنتجات المخفضة';

  @override
  String get feedEmpty => 'لا توجد منتجات';

  @override
  String get feedError => 'خطأ';

  @override
  String get feedRetry => 'إعادة المحاولة';

  @override
  String get filterTitle => 'الفلاتر';

  @override
  String get filterSortBy => 'ترتيب حسب';

  @override
  String get filterExpiry => 'تاريخ انتهاء';

  @override
  String get filterPopularity => 'الشعبية';

  @override
  String get filterRadius => 'المسافة (كم)';

  @override
  String get filterApply => 'تطبيق';

  @override
  String get filterCategory => 'الفئة';

  @override
  String get filterDistance => 'المسافة';

  @override
  String get categoryAll => 'الكل';

  @override
  String get categoryFood => 'غذائي';

  @override
  String get categoryCosmetique => 'مستحضرات تجميل';

  @override
  String get categoryElectro => 'إلكترونيات';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get contact => 'تواصل';

  @override
  String get discuss => 'دردشة';

  @override
  String get like => 'إعجاب';

  @override
  String likeCount(int count) {
    return '$count إعجاب';
  }

  @override
  String get comment => 'تعليق';

  @override
  String get comments => 'التعليقات';

  @override
  String get addComment => 'أضف تعليقًا...';

  @override
  String get anonymous => 'مجهول';

  @override
  String get uploadTitle => 'نشر منتج';

  @override
  String get uploadPhotos => 'صور المنتج';

  @override
  String get uploadCamera => 'الكاميرا';

  @override
  String get uploadGallery => 'المعرض';

  @override
  String get uploadProductTitle => 'اسم المنتج *';

  @override
  String get uploadDescription => 'الوصف (اختياري)';

  @override
  String get uploadCategory => 'الفئة *';

  @override
  String get uploadOriginalPrice => 'السعر الأصلي (ف CFA)';

  @override
  String get uploadPromoPrice => 'سعر التخفيض * (ف CFA)';

  @override
  String get uploadExpiryDate => 'تاريخ انتهاء الصلاحية *';

  @override
  String get uploadQuantity => 'الكمية *';

  @override
  String get uploadCity => 'المدينة (اختياري)';

  @override
  String get uploadValidate => 'تحقق ونشر';

  @override
  String get uploadSuccess => 'تم نشر المنتج بنجاح!';

  @override
  String uploadFailed(String reason) {
    return 'تم رفض المنتج: $reason';
  }

  @override
  String get uploadRequired => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get uploadAddImage => 'يرجى إضافة صورة واحدة على الأقل';

  @override
  String get uploadVideo => 'فيديو المنتج (اختياري)';

  @override
  String get uploadAddVideo => 'إضافة فيديو';

  @override
  String get uploadTitleHint => 'مثال: زبادي قريب من انتهاء الصلاحية';

  @override
  String get uploadDescriptionHint => 'وصف إضافي...';

  @override
  String get uploadSelectDate => 'اختر تاريخًا';

  @override
  String get uploadCityHint => 'مثال: بانغي';

  @override
  String get quantityHint => 'مثال: 5';

  @override
  String get uploadNotConnected => 'المستخدم غير متصل';

  @override
  String get uploadImageError => 'خطأ في رفع الصور';

  @override
  String get uploadAIError => 'خطأ في التحقق بالذكاء الاصطناعي';

  @override
  String get uploadPickError => 'خطأ في اختيار الصور';

  @override
  String get uploadCameraError => 'خطأ في التقاط الصورة';

  @override
  String get uploadVideoError => 'خطأ في اختيار الفيديو';

  @override
  String get uploadNotValidated => 'المنتج لم يتم التحقق منه';

  @override
  String get uploadOcrPrompt => 'لم يتم اكتشاف التاريخ — يرجى إدخاله يدويًا';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get validationPending => 'جارٍ التحقق...';

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
  String daysRemaining(int days) {
    return '$days يوم متبقي';
  }

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String quantity(int count) {
    return 'الكمية: $count';
  }

  @override
  String get merchantDashboard => 'لوحة التحكم';

  @override
  String get merchantProducts => 'منتجاتي';

  @override
  String get merchantStats => 'الإحصائيات';

  @override
  String get productsActive => 'المنتجات النشطة';

  @override
  String get views => 'المشاهدات';

  @override
  String get likes => 'الإعجابات';

  @override
  String get expiredProducts => 'منتهية الصلاحية';

  @override
  String get publishProduct => 'نشر منتج';

  @override
  String get manageProducts => 'إدارة منشوراتي';

  @override
  String get noProducts => 'لا توجد منتجات منشورة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get search => 'بحث';

  @override
  String get searchPlaceholder => 'ابحث عن منتج...';

  @override
  String get searchEmpty => 'اكتب للبحث';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeSystem => 'النظام';

  @override
  String get settingsAccount => 'الحساب';

  @override
  String get settingsProfile => 'الملف الشخصي';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get profile => 'ملفي الشخصي';

  @override
  String get errorGeneric => 'حدث خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get back => 'رجوع';

  @override
  String get begin => 'ابدأ';

  @override
  String get dailyLimitReached => 'تم الوصول إلى الحد اليومي';

  @override
  String dailyLimitFormat(
    int images,
    int imageLimit,
    int videos,
    int videoLimit,
  ) {
    return '$images/$imageLimit صور · $videos/$videoLimit فيديو اليوم';
  }

  @override
  String get premiumTitle => 'الترقية إلى بريميوم';

  @override
  String get premiumDescription => 'ارتقِ إلى بريميوم للنشر بلا حدود.';

  @override
  String get premiumCTA => 'الترقية إلى بريميوم';

  @override
  String get dailyLimitFreeTier => '5 صور · 2 فيديو في اليوم';

  @override
  String get goPremium => 'الترقية إلى بريميوم';

  @override
  String get premiumActive => 'بريميوم نشط';

  @override
  String get premiumUnlimited => 'تحميلات غير محدودة';

  @override
  String get premiumLimitReached => 'تم الوصول إلى الحد الأقصى';

  @override
  String get contactSupport => 'اتصل بالدعم لتفعيل بريميوم.';

  @override
  String get later => 'لاحقًا';
}
