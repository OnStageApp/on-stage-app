import 'package:dio/dio.dart';
import 'package:on_stage_app/app/shared/data/error/enums/error_category.dart';

abstract class AppException extends DioException {
  AppException({
    required this.category,
    required this.userMessage,
    this.technicalDetails,
    dynamic originalError,
  }) : super(
          requestOptions: RequestOptions(),
          error: originalError ?? userMessage,
          type: _mapCategoryToDioType(category),
        );

  final ErrorCategory category;
  final String userMessage;
  final String? technicalDetails;

  static DioExceptionType _mapCategoryToDioType(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.validation:
        return DioExceptionType.badResponse;
      case ErrorCategory.network:
        return DioExceptionType.connectionError;
      case ErrorCategory.authentication:
      case ErrorCategory.authorization:
      case ErrorCategory.notFound:
      case ErrorCategory.server:
        return DioExceptionType.badResponse;
      case ErrorCategory.unknown:
        return DioExceptionType.unknown;
    }
  }

  @override
  String toString() => userMessage;
}
