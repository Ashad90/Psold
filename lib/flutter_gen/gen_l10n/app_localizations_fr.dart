// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Psold';

  @override
  String get tagline => 'Les Produits en Solde';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginEmail => 'Adresse e-mail';

  @override
  String get loginPhone => 'Numéro de téléphone';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginWithEmail => 'Se connecter avec e-mail';

  @override
  String get loginWithPhone => 'Se connecter avec téléphone';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get roleClient => 'Client';

  @override
  String get roleMerchant => 'Marchand';

  @override
  String get roleCardMerchantTitle => 'Compte Marchand';

  @override
  String get roleCardMerchantSubtitle =>
      'Je vends des produits\nen solde ou proches de la date de péremption';

  @override
  String get roleCardClientTitle => 'Compte Client';

  @override
  String get roleCardClientSubtitle =>
      'Je cherche des bonnes affaires\nsur des produits en solde';

  @override
  String get merchantUploadFeatures =>
      'Upload de photos & vidéos produits,Validation IA automatique,Dashboard de statistiques,Visibilité auprès des acheteurs';

  @override
  String get clientFeatures =>
      'Parcourir les produits proches de moi,Liker et commenter les publications,Contacter le vendeur via WhatsApp,Notifications de nouvelles offres';

  @override
  String get onboardingWhatsapp => 'Numéro WhatsApp';

  @override
  String get onboardingCity => 'Ville';

  @override
  String get registerMerchantTitle => 'Inscription Marchand';

  @override
  String get registerClientTitle => 'Inscription Client';

  @override
  String get registerShopName => 'Nom de la boutique *';

  @override
  String get registerDisplayName => 'Prénom ou pseudo *';

  @override
  String get registerEmail => 'Email *';

  @override
  String get registerWhatsApp => 'Numéro WhatsApp *';

  @override
  String get registerCity => 'Ville *';

  @override
  String get registerCreateAccount => 'Créer mon compte';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? ';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get feedTitle => 'Produits en solde';

  @override
  String get feedEmpty => 'Aucun produit disponible';

  @override
  String get feedError => 'Erreur';

  @override
  String get feedRetry => 'Réessayer';

  @override
  String get filterTitle => 'Filtres';

  @override
  String get filterSortBy => 'Trier par';

  @override
  String get filterExpiry => 'Date péremption';

  @override
  String get filterPopularity => 'Popularité';

  @override
  String get filterRadius => 'Rayon (km)';

  @override
  String get filterApply => 'Appliquer';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get filterDistance => 'Distance';

  @override
  String get categoryAll => 'Tous';

  @override
  String get categoryFood => 'Alimentaire';

  @override
  String get categoryCosmetique => 'Cosmétique';

  @override
  String get categoryElectro => 'Électronique';

  @override
  String get categoryOther => 'Autre';

  @override
  String get contact => 'Contacter';

  @override
  String get discuss => 'Discuter';

  @override
  String get like => 'J\'aime';

  @override
  String likeCount(int count) {
    return '$count likes';
  }

  @override
  String get comment => 'Commenter';

  @override
  String get comments => 'Commentaires';

  @override
  String get addComment => 'Ajouter un commentaire...';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get uploadTitle => 'Publier un produit';

  @override
  String get uploadPhotos => 'Photos du produit';

  @override
  String get uploadCamera => 'Caméra';

  @override
  String get uploadGallery => 'Galerie';

  @override
  String get uploadProductTitle => 'Titre du produit *';

  @override
  String get uploadDescription => 'Description (optionnel)';

  @override
  String get uploadCategory => 'Catégorie *';

  @override
  String get uploadOriginalPrice => 'Prix original (FCFA)';

  @override
  String get uploadPromoPrice => 'Prix promo * (FCFA)';

  @override
  String get uploadExpiryDate => 'Date de péremption *';

  @override
  String get uploadQuantity => 'Quantité *';

  @override
  String get uploadCity => 'Ville (optionnel)';

  @override
  String get uploadValidate => 'Valider et publier';

  @override
  String get uploadSuccess => 'Produit publié avec succès !';

  @override
  String uploadFailed(String reason) {
    return 'Produit refusé : $reason';
  }

  @override
  String get uploadRequired => 'Veuillez remplir tous les champs obligatoires';

  @override
  String get uploadAddImage => 'Veuillez ajouter au moins une image';

  @override
  String get uploadVideo => 'Vidéo du produit (optionnel)';

  @override
  String get uploadAddVideo => 'Ajouter une vidéo';

  @override
  String get uploadTitleHint => 'Ex: Yaourt nature expire bientôt';

  @override
  String get uploadDescriptionHint => 'Description supplémentaire...';

  @override
  String get uploadSelectDate => 'Sélectionner une date';

  @override
  String get uploadCityHint => 'Ex: Bangui';

  @override
  String get quantityHint => 'Ex: 5';

  @override
  String get uploadNotConnected => 'Utilisateur non connecté';

  @override
  String get uploadImageError => 'Erreur lors de l\'upload des images';

  @override
  String get uploadAIError => 'Erreur de validation IA';

  @override
  String get uploadPickError => 'Erreur lors de la sélection des images';

  @override
  String get uploadCameraError => 'Erreur lors de la capture';

  @override
  String get uploadVideoError => 'Erreur lors de la sélection vidéo';

  @override
  String get uploadNotValidated => 'Produit non validé';

  @override
  String get uploadOcrPrompt =>
      'Date non détectée — veuillez la saisir manuellement';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get validationPending => 'Validation en cours…';

  @override
  String get validationSuccess => 'Produit publié avec succès';

  @override
  String validationFailed(String reason) {
    return 'Publication refusée : $reason';
  }

  @override
  String daysLeft(int days) {
    return '$days jours restants';
  }

  @override
  String daysRemaining(int days) {
    return '$days jour(s) restant(s)';
  }

  @override
  String get expired => 'Expiré';

  @override
  String quantity(int count) {
    return 'Qté: $count';
  }

  @override
  String get merchantDashboard => 'Mon Dashboard';

  @override
  String get merchantProducts => 'Mes Produits';

  @override
  String get merchantStats => 'Statistiques';

  @override
  String get productsActive => 'Produits actifs';

  @override
  String get views => 'Vues';

  @override
  String get likes => 'Likes';

  @override
  String get expiredProducts => 'Expirés';

  @override
  String get publishProduct => 'Publier un produit';

  @override
  String get manageProducts => 'Gérer mes publications';

  @override
  String get noProducts => 'Aucun produit publié';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get search => 'Rechercher';

  @override
  String get searchPlaceholder => 'Rechercher un produit...';

  @override
  String get searchEmpty => 'Tapez pour rechercher';

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsProfile => 'Profil';

  @override
  String get settingsLogout => 'Déconnexion';

  @override
  String get profile => 'Mon Profil';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get back => 'Retour';

  @override
  String get begin => 'Commencer';

  @override
  String get dailyLimitReached => 'Limite quotidienne atteinte';

  @override
  String dailyLimitFormat(
    int images,
    int imageLimit,
    int videos,
    int videoLimit,
  ) {
    return '$images/$imageLimit images · $videos/$videoLimit vidéos aujourd\'hui';
  }

  @override
  String get premiumTitle => 'Passer au Premium';

  @override
  String get premiumDescription =>
      'Passez au Premium pour publier sans limite.';

  @override
  String get premiumCTA => 'Passer au Premium';

  @override
  String get dailyLimitFreeTier => '5 images · 2 vidéos par jour';

  @override
  String get goPremium => 'Passer au Premium';

  @override
  String get premiumActive => 'Premium Actif';

  @override
  String get premiumUnlimited => 'Téléchargements illimités';

  @override
  String get premiumLimitReached => 'Limite atteinte';

  @override
  String get contactSupport => 'Contactez le support pour activer Premium.';

  @override
  String get later => 'Plus tard';

  @override
  String get onboardingSlide1Title => 'Découvrez les bonnes affaires';

  @override
  String get onboardingSlide1Description =>
      'Trouvez des produits frais à prix réduit près de chez vous';

  @override
  String get onboardingSlide2Title => 'Vendez facilement vos surplus';

  @override
  String get onboardingSlide2Description =>
      'Publiez vos produits en solde en quelques clics avec validation IA';

  @override
  String get onboardingSlide3Title => 'Discutez directement avec les vendeurs';

  @override
  String get onboardingSlide3Description =>
      'Contactez les marchands via WhatsApp pour finaliser vos achats';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';
}
