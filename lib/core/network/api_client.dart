import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/constants/api_constants.dart';
import 'package:flutter_boilerplate/core/constants/app_constants.dart';
import 'package:flutter_boilerplate/core/errors/exceptions.dart';
import 'package:flutter_boilerplate/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_boilerplate/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_boilerplate/core/network/network_info.dart';

class ApiClient {
  final Dio _dio;
  final NetworkInfo networkInfo;

  ApiClient({
    required Dio dio,
    required this.networkInfo,
  }) : _dio = dio {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = Duration(milliseconds: AppConstants.connectionTimeout)
      ..receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout)
      ..headers = {
        ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
        ApiConstants.acceptHeader: ApiConstants.contentTypeJson,
      }
      ..validateStatus = (status) {
        return status! < 500;
      };

    // Add interceptors
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(AuthInterceptor());
  }

  /// Performs a GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        throw NetworkException();
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Performs a POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        throw NetworkException();
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Performs a PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        throw NetworkException();
      }

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Performs a DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        throw NetworkException();
      }

      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Processes the API response
  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw ValidationException(
          _getErrorMessage(response),
          _extractFieldErrors(response),
        );
      case 401:
        throw UnauthorizedException(_getErrorMessage(response));
      case 403:
        throw ForbiddenException(_getErrorMessage(response));
      case 404:
        throw NotFoundException(_getErrorMessage(response));
      default:
        throw ServerException(_getErrorMessage(response), response.statusCode);
    }
  }

  /// Extracts error message from response
  String _getErrorMessage(Response response) {
    try {
      if (response.data != null && response.data is Map) {
        if (response.data['message'] != null) {
          return response.data['message'];
        } else if (response.data['error'] != null) {
          return response.data['error'];
        }
      }
      return 'Error occurred with status code: ${response.statusCode}';
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  /// Extracts field errors from validation response
  Map<String, List<String>>? _extractFieldErrors(Response response) {
    try {
      if (response.data != null &&
          response.data is Map &&
          response.data['errors'] != null &&
          response.data['errors'] is Map) {
        final Map<String, List<String>> fieldErrors = {};
        final Map<String, dynamic> errors = response.data['errors'];

        errors.forEach((key, value) {
          if (value is List) {
            fieldErrors[key] =
                List<String>.from(value.map((e) => e.toString()));
          } else if (value is String) {
            fieldErrors[key] = [value];
          }
        });

        return fieldErrors;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Handles errors from dio and network
  AppException _handleError(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException('Connection timed out');
        case DioExceptionType.badResponse:
          if (error.response != null) {
            switch (error.response!.statusCode) {
              case 400:
                return ValidationException(
                  _getErrorMessage(error.response!),
                  _extractFieldErrors(error.response!),
                );
              case 401:
                return UnauthorizedException(_getErrorMessage(error.response!));
              case 403:
                return ForbiddenException(_getErrorMessage(error.response!));
              case 404:
                return NotFoundException(_getErrorMessage(error.response!));
              case 500:
              case 501:
              case 502:
              case 503:
                return ServerException(
                  _getErrorMessage(error.response!),
                  error.response!.statusCode,
                );
              default:
                return ServerException(
                  'Error occurred with status code: ${error.response!.statusCode}',
                  error.response!.statusCode,
                );
            }
          }
          return ServerException('Unknown server error occurred');
        case DioExceptionType.cancel:
          return UnexpectedException('Request was cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return NetworkException('No internet connection');
          }
          return UnexpectedException(
              'Unexpected error occurred: ${error.message}');
        default:
          return UnexpectedException(
              'Unexpected error occurred: ${error.message}');
      }
    }

    return UnexpectedException('Unexpected error occurred: $error');
  }
}
