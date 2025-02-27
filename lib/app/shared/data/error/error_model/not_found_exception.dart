import 'package:on_stage_app/app/shared/data/error/enums/error_category.dart';
import 'package:on_stage_app/app/shared/data/error/error_model/app_exception.dart';

class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    super.technicalDetails,
    super.originalError,
  }) : super(
          category: ErrorCategory.notFound,
          userMessage: message,
        );
}
