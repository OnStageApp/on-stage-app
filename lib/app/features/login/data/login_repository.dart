import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'login_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class LoginRepository {
  factory LoginRepository(Dio dio, {String baseUrl}) = _LoginRepository;

  @POST(API.verifyToken)
  Future<User> verifyToken(
    @Body() String idToken,
  );
}
