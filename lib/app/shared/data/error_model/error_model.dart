import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

@freezed
class ApiErrorResponse with _$ApiErrorResponse {
  const factory ApiErrorResponse({
    required String? errorDescription,
    required ErrorType? errorName,
    required int? errorCode,
    PermissionType? param,
  }) = _ApiErrorResponse;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
}
