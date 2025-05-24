class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
  
  // App info
  static const String appName = 'Flutter Boilerplate';
  static const String appVersion = '1.0.0';
  
  // Timeout durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  // Animation durations
  static const int shortAnimationDuration = 150; // milliseconds
  static const int mediumAnimationDuration = 300; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // App defaults
  static const String defaultLanguage = 'en';
  static const String defaultCountryCode = 'US';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 50;
  
  // Cache expiry
  static const int defaultCacheValidityDuration = 60 * 60 * 24; // 24 hours
}