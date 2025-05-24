import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
      printTime: false,
    ),
  );

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i('REQUEST[${options.method}] => '
          'PATH: ${options.path}\n'
          'HEADERS: ${options.headers}\n'
          'QUERY PARAMETERS: ${options.queryParameters}\n'
          'DATA: ${options.data}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i('RESPONSE[${response.statusCode}] => '
          'PATH: ${response.requestOptions.path}\n'
          'DATA: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e('ERROR[${err.response?.statusCode}] => '
          'PATH: ${err.requestOptions.path}\n'
          'MESSAGE: ${err.message}\n'
          'DATA: ${err.response?.data}');
    }
    return super.onError(err, handler);
  }
}