import 'package:intl/intl.dart';
import 'package:price_alert/core/constants/api_constants.dart';

class Helpers {
  Helpers._();

  static String formatPrice(double price, {String currency = '₺'}) {
    final formatter = NumberFormat('#,##0.00', 'tr_TR');

    return '${formatter.format(price)} $currency';
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'tr_TR');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy HH:mm', 'tr_TR');
    return formatter.format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Az önce';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks hafta önce';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    }
  }

  static double calculatePriceChangePercentage(
    double oldPrice,
    double newPrice,
  ) {
    if (oldPrice == 0) return 0;
    return ((newPrice - oldPrice) / oldPrice) * 100;
  }

  static String formatPriceChange(double oldPrice, double newPrice) {
    final percentage = calculatePriceChangePercentage(oldPrice, newPrice);
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}%';
  }

  static String extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (e) {
      return '';
    }
  }

  static bool isSupportedSite(String url) {
    final domain = extractDomain(url);
    return ApiConstants.supportedSites.any((site) => domain.contains(site));
  }

  static String getSiteName(String url) {
    final domain = extractDomain(url);

    if (domain.contains('trendyol')) return 'Trendyol';
    if (domain.contains('hepsiburada')) return 'Hepsiburada';
    if (domain.contains('amazon')) return 'Amazon';
    if (domain.contains('n11')) return 'N11';
    if (domain.contains('gittigidiyor')) return 'GittiGidiyor';

    return 'Diğer';
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static double? parsePriceString(String priceString) {
    try {
      // Remove currency symbols and spaces
      final cleaned = priceString
          .replaceAll('₺', '')
          .replaceAll('TL', '')
          .replaceAll('TRY', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();

      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static bool isOnSale(double currentPrice, double originalPrice) {
    return currentPrice < originalPrice;
  }

  static double calculateDiscountAmount(
    double originalPrice,
    double salePrice,
  ) {
    return originalPrice - salePrice;
  }

  static String formatDiscountPercentge(
    double originalPrice,
    double salePrice,
  ) {
    if (originalPrice == 0) return '0%';
    final discount = ((originalPrice - salePrice) / originalPrice) * 100;
    return '%${discount.toStringAsFixed(0)}';
  }

  static void showSnackBar(
    dynamic context,
    String message, {
    bool isError = false,
  }) {}

  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 11) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7, 9)} ${cleaned.substring(9)}';
    }
    return phone;
  }

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static bool isValidJson(String jsonString) {
    try {
      return jsonString.startsWith('{') || jsonString.startsWith('[');
    } catch (e) {
      return false;
    }
  }
}
