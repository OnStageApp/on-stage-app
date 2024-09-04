import 'package:on_stage_app/app/utils/app_error.dart';
import 'package:on_stage_app/logger.dart';

class ErrorHandler {
  static AppError handleError(dynamic error, String context) {
    final appError = AppError.fromException(error);
    logger.e('$context: $appError');
    return appError;
  }
}
