
import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static Future<void> openChat({required String phoneNumber, required String productTitle}) async {
    final cleanPhone = phoneNumber.replaceAll('+', '').replaceAll(' ', '');
    final message = Uri.encodeComponent('Bonjour, je suis intéressé par votre produit "$productTitle" publié sur Psold. Est-il encore disponible ?');
    final url = Uri.parse('https://wa.me/$cleanPhone?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class DateHelper {
  static int daysUntil(DateTime date) => date.difference(DateTime.now()).inDays;
  static String formatExpiryDate(DateTime date) {
    final days = daysUntil(date);
    if (days <= 0) return 'Expiré';
    if (days == 1) return 'Expire demain';
    if (days <= 7) return 'Expire dans $days jours';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class PriceHelper {
  static String formatPrice(double price, {String currency = 'CFA'}) => '${price.toInt()} $currency';
  static String formatDiscount(double original, double promo) {
    if (original <= 0) return '';
    return '-${((original - promo) / original * 100).round()}%';
  }
}

class ValidationHelper {
  static bool isValidWhatsAppNumber(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');
    return cleanPhone.length >= 8 && cleanPhone.length <= 15;
  }

  static bool isValidEmail(String email) => email.contains('@') && email.contains('.');
}