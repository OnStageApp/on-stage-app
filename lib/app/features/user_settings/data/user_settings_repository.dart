import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/user_settings/domain/user_settings.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'user_settings_repository.g.dart';

@RestApi()
abstract class UserSettingsRepository {
  factory UserSettingsRepository(Dio dio) = _UserSettingsRepository;

  @GET(API.userSettings)
  Future<UserSettings> getUserSettings();

  @POST(API.userSettings)
  Future<UserSettings> createUserSettings({
    @Body() required UserSettings userSettings,
  });

  @PUT(API.userSettings)
  Future<UserSettings> updateUserSettings({
    @Body() required UserSettings userSettings,
  });
}
