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
  String get registerTitle => 'Créer un compte';

  @override
  String get roleClient => 'Client';

  @override
  String get roleMerchant => 'Marchand';

  @override
  String get onboardingWhatsapp => 'Numéro WhatsApp';

  @override
  String get onboardingCity => 'Ville';

  @override
  String get feedTitle => 'Produits en solde';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get filterDistance => 'Distance';

  @override
  String get categoryFood => 'Alimentaire';

  @override
  String get categoryElectro => 'Électronique';

  @override
  String get categoryCosmetique => 'Cosmétique';

  @override
  String get categoryOther => 'Autre';

  @override
  String get contact => 'Contacter';

  @override
  String get like => 'J\'aime';

  @override
  String get comment => 'Commenter';

  @override
  String get uploadTitle => 'Publier un produit';

  @override
  String get uploadExpiryDate => 'Date de péremption';

  @override
  String get uploadPrice => 'Prix en solde';

  @override
  String get uploadOriginalPrice => 'Prix original';

  @override
  String get uploadQuantity => 'Quantité';

  @override
  String get uploadValidate => 'Valider et publier';

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
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get logout => 'Se déconnecter';
}
