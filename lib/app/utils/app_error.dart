import 'package:dio/dio.dart';

class AppError implements Exception {
  AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  factory AppError.fromException(dynamic error) {
    if (error is DioException) {
      return AppError._fromDioError(error);
    } else if (error is AppError) {
      return error;
    } else {
      return AppError(
        message: error.toString(),
        code: 'unexpected_error',
        originalError: error,
      );
    }
  }

  factory AppError._fromDioError(DioException error) {
    String message;
    String code;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message =
            'Connection timeout. Please check your internet connection and try again.';
        code = 'timeout_error';
      case DioExceptionType.badResponse:
        message = _handleBadResponse(error.response?.statusCode);
        code = 'http_error_${error.response?.statusCode}';
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        code = 'request_cancelled';
      default:
        message = 'An unexpected error occurred. Please try again.';
        code = 'network_error';
    }

    return AppError(
      message: message,
      code: code,
      originalError: error,
    );
  }

  final String message;
  final String? code;
  final dynamic originalError;

  static String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input and try again.';
      case 401:
        return 'Unauthorized. Please log in and try again.';
      case 403:
        return "Forbidden. You don't have permission to access this resource.";
      case 404:
        return 'Resource not found. Please check your request and try again.';
      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'AppError: $message (Code: $code)';
}
