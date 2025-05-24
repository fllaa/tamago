class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();
  
  // Base URLs
  static const String baseUrl = 'https://api.example.com/v1';
  static const String assetBaseUrl = 'https://assets.example.com';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';
  
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  
  static const String products = '/products';
  static const String categories = '/categories';
  
  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String bearerPrefix = 'Bearer ';
  
  // Content types
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';
  
  // Error codes
  static const int unauthorizedError = 401;
  static const int forbiddenError = 403;
  static const int notFoundError = 404;
  static const int serverError = 500;
  
  // Pagination parameters
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String offsetParam = 'offset';
  static const String searchParam = 'search';
  static const String sortParam = 'sort';
  static const String orderParam = 'order';
}