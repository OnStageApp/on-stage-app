import 'package:on_stage_app/app/shared/data/error/enums/error_category.dart';

class ApiErrorResult {
  ApiErrorResult({
    required this.message,
    required this.originalError,
    required this.errorCategory,
    this.statusCode,
    this.errorCode,
    this.errorName,
  });
  
  final String message;
  final Object originalError;
  final int? statusCode;
  final String? errorCode;
  final String? errorName;
  final ErrorCategory errorCategory;

  bool get isValidationError => errorCategory == ErrorCategory.validation;
  bool get isNetworkError => errorCategory == ErrorCategory.network;
  bool get isAuthenticationError =>
      errorCategory == ErrorCategory.authentication;
  bool get isAuthorizationError => errorCategory == ErrorCategory.authorization;
  bool get isNotFoundError => errorCategory == ErrorCategory.notFound;
  bool get isServerError => errorCategory == ErrorCategory.server;

  @override
  String toString() => message;
}
