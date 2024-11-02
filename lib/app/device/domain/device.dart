import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/enums/platform_type.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class Device with _$Device {
  const factory Device({
    required String id,
    required String deviceId,
    required PlatformType platformType,
    required String appVersion,
    required String osVersion,
    required String buildVersion,
    String? pushToken,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}

//TODO: check for device info changes and update device info in backend
