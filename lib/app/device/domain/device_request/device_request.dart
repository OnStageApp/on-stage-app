import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/enums/platform_type.dart';

part 'device_request.freezed.dart';
part 'device_request.g.dart';

@freezed
class DeviceRequest with _$DeviceRequest {
  const factory DeviceRequest({
    required String deviceId,
    PlatformType? platformType,
    String? appVersion,
    String? osVersion,
    String? buildVersion,
    String? pushToken,
  }) = _DeviceRequest;

  factory DeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRequestFromJson(json);
}
