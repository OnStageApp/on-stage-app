import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

part 'stager_request.freezed.dart';
part 'stager_request.g.dart';

@Freezed()
class StagerRequest with _$StagerRequest {
  const factory StagerRequest({
    String? name,
    StagerStatusEnum? participationStatus,
  }) = _StagerRequest;

  factory StagerRequest.fromJson(Map<String, dynamic> json) =>
      _$StagerRequestFromJson(json);
}
