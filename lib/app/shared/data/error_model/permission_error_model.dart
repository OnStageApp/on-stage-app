import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';

part 'permission_error_model.freezed.dart';
part 'permission_error_model.g.dart';

@freezed
class PermissionErrorResponse with _$PermissionErrorResponse {
  const factory PermissionErrorResponse({
    required String? errorDescription,
    required ErrorType? errorName,
    required int? errorCode,
    PermissionType? param,
  }) = _PermissionErrorResponse;

  factory PermissionErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$PermissionErrorResponseFromJson(json);
}
