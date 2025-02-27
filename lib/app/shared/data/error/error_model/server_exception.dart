import 'package:on_stage_app/app/shared/data/error/enums/error_category.dart';
import 'package:on_stage_app/app/shared/data/error/error_model/app_exception.dart';

class ServerException extends AppException {
  ServerException({
    required String message,
    super.technicalDetails,
    super.originalError,
  }) : super(
          category: ErrorCategory.server,
          userMessage: message,
        );
}
