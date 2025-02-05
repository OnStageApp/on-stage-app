import 'package:dio/dio.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/error_model.dart';
import 'package:on_stage_app/logger.dart';

class ApiErrorHandler {
  static String handleDioException(DioException e) {
    try {
      if (e.response?.statusCode == 400) {
        final data = e.response?.data as Map<String, dynamic>;
        final errorResponse = ApiErrorResponse.fromJson(data);

        return errorResponse.errorDescription ??
            _getErrorMessageFromType(errorResponse.errorName) ??
            'An error occurred';
      }

      return _handleStatusCodeError(e.response?.statusCode) ??
          e.message ??
          'Network error occurred';
    } catch (parsingError) {
      logger.e('Error parsing API error response', parsingError);
      return 'An unexpected error occurred';
    }
  }

  static String? _getErrorMessageFromType(ErrorType? errorType) {
    if (errorType == null) return null;
    return errorType.getDescription('');
  }

  static String? _handleStatusCodeError(int? statusCode) {
    switch (statusCode) {
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      case 503:
        return 'Service unavailable';
      default:
        return null;
    }
  }
}
