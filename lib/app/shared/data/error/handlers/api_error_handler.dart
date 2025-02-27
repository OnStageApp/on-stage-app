import 'package:dio/dio.dart';
import 'package:on_stage_app/app/shared/data/error/enums/error_category.dart';
import 'package:on_stage_app/app/shared/data/error/error_model/api_error_result.dart';
import 'package:on_stage_app/app/shared/data/error/error_model/app_exception.dart';

class ApiErrorHandler {
  static ApiErrorResult handleError(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return ApiErrorResult(
        message: error.userMessage,
        originalError: error,
        statusCode: _getCategoryStatusCode(error.category),
        errorCategory: error.category,
      );
    } else if (error is DioException) {
      return _handleDioException(error, stackTrace);
    } else {
      return ApiErrorResult(
        message: error.toString(),
        originalError: error,
        errorCategory: ErrorCategory.unknown,
      );
    }
  }

  static ApiErrorResult _handleDioException(
    DioException error, [
    StackTrace? stackTrace,
  ]) {
    try {
      final statusCode = error.response?.statusCode;
      var errorMessage = 'Unknown error occurred';
      String? errorCode;
      String? errorName;

      if (error.response?.data != null) {
        if (error.response!.data is Map<String, dynamic>) {
          final data = error.response!.data as Map<String, dynamic>;

          // Attempt to parse error response
          errorMessage = data['message']?.toString() ?? 'An error occurred';
          errorCode = data['errorCode']?.toString();
          errorName = data['errorName']?.toString();
        }
      }

      final category = _getErrorCategory(statusCode, error.type);

      return ApiErrorResult(
        message: errorMessage,
        originalError: error,
        statusCode: statusCode,
        errorCode: errorCode,
        errorName: errorName,
        errorCategory: category,
      );
    } catch (e) {
      return ApiErrorResult(
        message: 'An unexpected error occurred',
        originalError: error,
        statusCode: error.response?.statusCode,
        errorCategory: ErrorCategory.unknown,
      );
    }
  }

  static int? _getCategoryStatusCode(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.validation:
        return 400;
      case ErrorCategory.authentication:
        return 401;
      case ErrorCategory.authorization:
        return 403;
      case ErrorCategory.notFound:
        return 404;
      case ErrorCategory.server:
        return 500;
      case ErrorCategory.unknown:
      case ErrorCategory.network:
        return null;
    }
  }

  static ErrorCategory _getErrorCategory(
    int? statusCode,
    DioExceptionType? exceptionType,
  ) {
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ErrorCategory.validation;
        case 401:
          return ErrorCategory.authentication;
        case 403:
          return ErrorCategory.authorization;
        case 404:
          return ErrorCategory.notFound;
        case 500:
        case 502:
        case 503:
        case 504:
          return ErrorCategory.server;
        default:
          return ErrorCategory.unknown;
      }
    }

    if (exceptionType != null) {
      switch (exceptionType) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return ErrorCategory.network;
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
      }
    }

    return ErrorCategory.unknown;
  }
}
