import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'song_config_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class SongConfigRepository {
  factory SongConfigRepository(Dio dio) = _SongConfigRepository;

  @GET(API.songConfigBySongId)
  Future<SongConfig> getSongConfig({
    @Path('songId') String? songId,
  });

  @POST(API.songConfig)
  Future<SongConfig> createSongConfig({
    @Body() SongConfigRequest? songConfigRequest,
  });
}
