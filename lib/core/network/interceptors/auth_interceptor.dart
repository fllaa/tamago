import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/constants/api_constants.dart';
import 'package:flutter_boilerplate/core/constants/app_constants.dart';
import 'package:flutter_boilerplate/core/services/storage_service.dart';
import 'package:flutter_boilerplate/di/injection_container.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService = getIt<StorageService>();
  
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.get(AppConstants.tokenKey);
    
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] = 
          '${ApiConstants.bearerPrefix}$token';
    }
    
    return super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh if 401 error
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _refreshToken();
        if (refreshToken != null) {
          // Retry the original request with the new token
          final options = err.requestOptions;
          options.headers[ApiConstants.authorizationHeader] = 
              '${ApiConstants.bearerPrefix}$refreshToken';
          
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Token refresh failed, log out user
        await _logoutUser();
      }
    }
    
    return super.onError(err, handler);
  }
  
  /// Refreshes the auth token
  Future<String?> _refreshToken() async {
    try {
      // Here would be the implementation to refresh the token
      // This is a placeholder
      // In a real app, you would call your refresh token endpoint
      
      // Save the new token
      // await _storageService.set(AppConstants.tokenKey, newToken);
      
      // Return the new token
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Logs out the user by clearing storage
  Future<void> _logoutUser() async {
    await _storageService.clear();
    // Navigate to login screen
    // In a real app, you would use a navigation service or event bus to trigger navigation
  }
}