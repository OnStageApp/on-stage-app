import 'package:dio/dio.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'login_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class LoginRepository {
  factory LoginRepository(Dio dio) = _LoginRepository;

  @POST(API.login)
  Future<String> login(
    @Body() String idToken,
  );
}
