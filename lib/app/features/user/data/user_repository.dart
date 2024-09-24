import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/features/user/domain/models/user/user_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class UserRepository {
  factory UserRepository(Dio dio) = _UserRepository;

  @GET(API.users)
  Future<List<User>> getUsers();

  @GET(API.currentUser)
  Future<UserModel> getCurrentUser();

  @GET(API.user)
  Future<UserModel> getUserById(
    @Path('id') String id,
  );

  @GET(API.userPhoto)
  Future<String> getUserPhotoUrl();

  @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getUserPhotoFromS3(@Path('path') String path);
}
