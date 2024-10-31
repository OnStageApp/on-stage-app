import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/login/domain/login_request_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'login_repository.g.dart';

@RestApi(baseUrl: API.baseUrl, parser: Parser.FlutterCompute)
abstract class LoginRepository {
  factory LoginRepository(Dio dio) = _LoginRepository;

  @POST(API.login)
  Future<dynamic> login(
    @Body() LoginRequest loginRequest,
  );

  @POST(API.logout)
  Future<void> logout(
    @Path('deviceId') String deviceId,
  );
}
