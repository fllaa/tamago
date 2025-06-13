// Exception classes for different error types

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? url;

  AppException(this.message, [this.prefix, this.url]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

/// Exception for network failures
class NetworkException extends AppException {
  NetworkException([String? message])
      : super(message ?? 'No internet connection', 'Network Error: ');
}

/// Exception for server failures
class ServerException extends AppException {
  final int? statusCode;

  ServerException([String? message, this.statusCode])
      : super(message ?? 'Server error occurred', 'Server Error: ');
}

/// Exception for cache failures
class CacheException extends AppException {
  CacheException([String? message])
      : super(message ?? 'Cache error occurred', 'Cache Error: ');
}

/// Exception for authentication failures
class AuthException extends AppException {
  AuthException([String? message])
      : super(message ?? 'Authentication failed', 'Auth Error: ');
}

/// Exception for validation failures
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException([String? message, this.errors])
      : super(message ?? 'Validation failed', 'Validation Error: ');
}

/// Exception for API timeouts
class TimeoutException extends AppException {
  TimeoutException([String? message])
      : super(message ?? 'Connection timeout', 'Timeout Error: ');
}

/// Exception for not found resources
class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message ?? 'Resource not found', 'Not Found: ', url);
}

/// Exception for format failures
class FormatException extends AppException {
  FormatException([String? message])
      : super(message ?? 'Invalid format', 'Format Error: ');
}

/// Exception for unauthorized access
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message ?? 'Unauthorized access', 'Unauthorized: ');
}

/// Exception for forbidden access
class ForbiddenException extends AppException {
  ForbiddenException([String? message])
      : super(message ?? 'Forbidden access', 'Forbidden: ');
}

/// Exception for unexpected errors
class UnexpectedException extends AppException {
  UnexpectedException([String? message])
      : super(message ?? 'Unexpected error occurred', 'Unexpected Error: ');
}
