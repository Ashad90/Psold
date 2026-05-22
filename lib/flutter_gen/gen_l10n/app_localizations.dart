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
/// import 'gen_l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Psold'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In fr, this message translates to:
  /// **'Les Produits en Solde'**
  String get tagline;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get loginEmail;

  /// No description provided for @loginPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get loginPhone;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @loginWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec e-mail'**
  String get loginWithEmail;

  /// No description provided for @loginWithPhone.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec téléphone'**
  String get loginWithPhone;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerTitle;

  /// No description provided for @roleClient.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get roleClient;

  /// No description provided for @roleMerchant.
  ///
  /// In fr, this message translates to:
  /// **'Marchand'**
  String get roleMerchant;

  /// No description provided for @roleCardMerchantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte Marchand'**
  String get roleCardMerchantTitle;

  /// No description provided for @roleCardMerchantSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Je vends des produits\nen solde ou proches de la date de péremption'**
  String get roleCardMerchantSubtitle;

  /// No description provided for @roleCardClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte Client'**
  String get roleCardClientTitle;

  /// No description provided for @roleCardClientSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Je cherche des bonnes affaires\nsur des produits en solde'**
  String get roleCardClientSubtitle;

  /// No description provided for @merchantUploadFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Upload de photos & vidéos produits,Validation IA automatique,Dashboard de statistiques,Visibilité auprès des acheteurs'**
  String get merchantUploadFeatures;

  /// No description provided for @clientFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Parcourir les produits proches de moi,Liker et commenter les publications,Contacter le vendeur via WhatsApp,Notifications de nouvelles offres'**
  String get clientFeatures;

  /// No description provided for @onboardingWhatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Numéro WhatsApp'**
  String get onboardingWhatsapp;

  /// No description provided for @onboardingCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get onboardingCity;

  /// No description provided for @registerMerchantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription Marchand'**
  String get registerMerchantTitle;

  /// No description provided for @registerClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription Client'**
  String get registerClientTitle;

  /// No description provided for @registerShopName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la boutique *'**
  String get registerShopName;

  /// No description provided for @registerDisplayName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom ou pseudo *'**
  String get registerDisplayName;

  /// No description provided for @registerEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email *'**
  String get registerEmail;

  /// No description provided for @registerWhatsApp.
  ///
  /// In fr, this message translates to:
  /// **'Numéro WhatsApp *'**
  String get registerWhatsApp;

  /// No description provided for @registerCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville *'**
  String get registerCity;

  /// No description provided for @registerCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerCreateAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginLink;

  /// No description provided for @feedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Produits en solde'**
  String get feedTitle;

  /// No description provided for @feedEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit disponible'**
  String get feedEmpty;

  /// No description provided for @feedError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get feedError;

  /// No description provided for @feedRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get feedRetry;

  /// No description provided for @filterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filterTitle;

  /// No description provided for @filterSortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get filterSortBy;

  /// No description provided for @filterExpiry.
  ///
  /// In fr, this message translates to:
  /// **'Date péremption'**
  String get filterExpiry;

  /// No description provided for @filterPopularity.
  ///
  /// In fr, this message translates to:
  /// **'Popularité'**
  String get filterPopularity;

  /// No description provided for @filterRadius.
  ///
  /// In fr, this message translates to:
  /// **'Rayon (km)'**
  String get filterRadius;

  /// No description provided for @filterApply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get filterApply;

  /// No description provided for @filterCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get filterCategory;

  /// No description provided for @filterDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get filterDistance;

  /// No description provided for @categoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get categoryAll;

  /// No description provided for @categoryFood.
  ///
  /// In fr, this message translates to:
  /// **'Alimentaire'**
  String get categoryFood;

  /// No description provided for @categoryCosmetique.
  ///
  /// In fr, this message translates to:
  /// **'Cosmétique'**
  String get categoryCosmetique;

  /// No description provided for @categoryElectro.
  ///
  /// In fr, this message translates to:
  /// **'Électronique'**
  String get categoryElectro;

  /// No description provided for @categoryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get categoryOther;

  /// No description provided for @contact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get contact;

  /// No description provided for @discuss.
  ///
  /// In fr, this message translates to:
  /// **'Discuter'**
  String get discuss;

  /// No description provided for @like.
  ///
  /// In fr, this message translates to:
  /// **'J\'aime'**
  String get like;

  /// No description provided for @likeCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} likes'**
  String likeCount(int count);

  /// No description provided for @comment.
  ///
  /// In fr, this message translates to:
  /// **'Commenter'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In fr, this message translates to:
  /// **'Commentaires'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un commentaire...'**
  String get addComment;

  /// No description provided for @anonymous.
  ///
  /// In fr, this message translates to:
  /// **'Anonyme'**
  String get anonymous;

  /// No description provided for @uploadTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publier un produit'**
  String get uploadTitle;

  /// No description provided for @uploadPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Photos du produit'**
  String get uploadPhotos;

  /// No description provided for @uploadCamera.
  ///
  /// In fr, this message translates to:
  /// **'Caméra'**
  String get uploadCamera;

  /// No description provided for @uploadGallery.
  ///
  /// In fr, this message translates to:
  /// **'Galerie'**
  String get uploadGallery;

  /// No description provided for @uploadProductTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre du produit *'**
  String get uploadProductTitle;

  /// No description provided for @uploadDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description (optionnel)'**
  String get uploadDescription;

  /// No description provided for @uploadCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie *'**
  String get uploadCategory;

  /// No description provided for @uploadOriginalPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix original (FCFA)'**
  String get uploadOriginalPrice;

  /// No description provided for @uploadPromoPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix promo * (FCFA)'**
  String get uploadPromoPrice;

  /// No description provided for @uploadExpiryDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de péremption *'**
  String get uploadExpiryDate;

  /// No description provided for @uploadQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité *'**
  String get uploadQuantity;

  /// No description provided for @uploadCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville (optionnel)'**
  String get uploadCity;

  /// No description provided for @uploadValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider et publier'**
  String get uploadValidate;

  /// No description provided for @uploadSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Produit publié avec succès !'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In fr, this message translates to:
  /// **'Produit refusé : {reason}'**
  String uploadFailed(String reason);

  /// No description provided for @uploadRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs obligatoires'**
  String get uploadRequired;

  /// No description provided for @uploadAddImage.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez ajouter au moins une image'**
  String get uploadAddImage;

  /// No description provided for @uploadVideo.
  ///
  /// In fr, this message translates to:
  /// **'Vidéo du produit (optionnel)'**
  String get uploadVideo;

  /// No description provided for @uploadAddVideo.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une vidéo'**
  String get uploadAddVideo;

  /// No description provided for @uploadTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Yaourt nature expire bientôt'**
  String get uploadTitleHint;

  /// No description provided for @uploadDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Description supplémentaire...'**
  String get uploadDescriptionHint;

  /// No description provided for @uploadSelectDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date'**
  String get uploadSelectDate;

  /// No description provided for @uploadCityHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Bangui'**
  String get uploadCityHint;

  /// No description provided for @quantityHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 5'**
  String get quantityHint;

  /// No description provided for @uploadNotConnected.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecté'**
  String get uploadNotConnected;

  /// No description provided for @uploadImageError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'upload des images'**
  String get uploadImageError;

  /// No description provided for @uploadAIError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de validation IA'**
  String get uploadAIError;

  /// No description provided for @uploadPickError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la sélection des images'**
  String get uploadPickError;

  /// No description provided for @uploadCameraError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la capture'**
  String get uploadCameraError;

  /// No description provided for @uploadVideoError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la sélection vidéo'**
  String get uploadVideoError;

  /// No description provided for @uploadNotValidated.
  ///
  /// In fr, this message translates to:
  /// **'Produit non validé'**
  String get uploadNotValidated;

  /// No description provided for @uploadOcrPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Date non détectée — veuillez la saisir manuellement'**
  String get uploadOcrPrompt;

  /// No description provided for @profileUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour'**
  String get profileUpdated;

  /// No description provided for @validationPending.
  ///
  /// In fr, this message translates to:
  /// **'Validation en cours…'**
  String get validationPending;

  /// No description provided for @validationSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Produit publié avec succès'**
  String get validationSuccess;

  /// No description provided for @validationFailed.
  ///
  /// In fr, this message translates to:
  /// **'Publication refusée : {reason}'**
  String validationFailed(String reason);

  /// No description provided for @daysLeft.
  ///
  /// In fr, this message translates to:
  /// **'{days} jours restants'**
  String daysLeft(int days);

  /// No description provided for @daysRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{days} jour(s) restant(s)'**
  String daysRemaining(int days);

  /// No description provided for @expired.
  ///
  /// In fr, this message translates to:
  /// **'Expiré'**
  String get expired;

  /// No description provided for @quantity.
  ///
  /// In fr, this message translates to:
  /// **'Qté: {count}'**
  String quantity(int count);

  /// No description provided for @merchantDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Mon Dashboard'**
  String get merchantDashboard;

  /// No description provided for @merchantProducts.
  ///
  /// In fr, this message translates to:
  /// **'Mes Produits'**
  String get merchantProducts;

  /// No description provided for @merchantStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get merchantStats;

  /// No description provided for @productsActive.
  ///
  /// In fr, this message translates to:
  /// **'Produits actifs'**
  String get productsActive;

  /// No description provided for @views.
  ///
  /// In fr, this message translates to:
  /// **'Vues'**
  String get views;

  /// No description provided for @likes.
  ///
  /// In fr, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @expiredProducts.
  ///
  /// In fr, this message translates to:
  /// **'Expirés'**
  String get expiredProducts;

  /// No description provided for @publishProduct.
  ///
  /// In fr, this message translates to:
  /// **'Publier un produit'**
  String get publishProduct;

  /// No description provided for @manageProducts.
  ///
  /// In fr, this message translates to:
  /// **'Gérer mes publications'**
  String get manageProducts;

  /// No description provided for @noProducts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit publié'**
  String get noProducts;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get noNotifications;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un produit...'**
  String get searchPlaceholder;

  /// No description provided for @searchEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Tapez pour rechercher'**
  String get searchEmpty;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get settingsAccount;

  /// No description provided for @settingsProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get settingsProfile;

  /// No description provided for @settingsLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get settingsLogout;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get profile;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @begin.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get begin;

  /// No description provided for @dailyLimitReached.
  ///
  /// In fr, this message translates to:
  /// **'Limite quotidienne atteinte'**
  String get dailyLimitReached;

  /// No description provided for @dailyLimitFormat.
  ///
  /// In fr, this message translates to:
  /// **'{images}/{imageLimit} images · {videos}/{videoLimit} vidéos aujourd\'hui'**
  String dailyLimitFormat(
    int images,
    int imageLimit,
    int videos,
    int videoLimit,
  );

  /// No description provided for @premiumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passer au Premium'**
  String get premiumTitle;

  /// No description provided for @premiumDescription.
  ///
  /// In fr, this message translates to:
  /// **'Passez au Premium pour publier sans limite.'**
  String get premiumDescription;

  /// No description provided for @premiumCTA.
  ///
  /// In fr, this message translates to:
  /// **'Passer au Premium'**
  String get premiumCTA;

  /// No description provided for @dailyLimitFreeTier.
  ///
  /// In fr, this message translates to:
  /// **'5 images · 2 vidéos par jour'**
  String get dailyLimitFreeTier;

  /// No description provided for @goPremium.
  ///
  /// In fr, this message translates to:
  /// **'Passer au Premium'**
  String get goPremium;

  /// No description provided for @premiumActive.
  ///
  /// In fr, this message translates to:
  /// **'Premium Actif'**
  String get premiumActive;

  /// No description provided for @premiumUnlimited.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargements illimités'**
  String get premiumUnlimited;

  /// No description provided for @premiumLimitReached.
  ///
  /// In fr, this message translates to:
  /// **'Limite atteinte'**
  String get premiumLimitReached;

  /// No description provided for @contactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Contactez le support pour activer Premium.'**
  String get contactSupport;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
