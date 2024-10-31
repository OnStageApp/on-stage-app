// lib/app/features/device/data/device_repository.dart
import 'package:dio/dio.dart';
import 'package:on_stage_app/app/device/domain/device.dart';
import 'package:on_stage_app/app/device/domain/device_request/device_request.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'device_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class DeviceRepository {
  factory DeviceRepository(Dio dio) = _DeviceRepository;

  @POST(API.deviceLogin)
  Future<void> loginDevice(@Body() DeviceRequest device);

  @PUT(API.deviceById)
  Future<void> updateDevice(
    @Path('deviceId') String deviceId,
    @Body() DeviceRequest device,
  );
}
