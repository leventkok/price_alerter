class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://us-central1-pricealert.cloudfunctions.net';

  static const String scrapeProductEndpoint = '/scrapeProduct';
  static const String checkPriceEndpoint = '/checkPrice';
  static const String trackProductEndpoint = 'trackProduct';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const List<String> supportedSites = [
    'trendyol.com',
    'hepsiburada.com',
    'amazon.com.tr',
    'n11.com',
    'gittigidiyor.com',
  ];
}
