class AppConstants {
  AppConstants._();

  static const String appName = 'Price Alerter';
  static const String appVersion = '1.0.0';

  static const int connectionTimeout = 30000;
  static const int recieveTimeout = 30000;

  static const int itemsPerPage = 20;

  static const Duration pricecheckInterval = Duration(hours: 6);

  static const Duration cacheValidDuration = Duration(hours: 1);
}
