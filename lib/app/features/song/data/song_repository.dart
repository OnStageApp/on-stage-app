import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'song_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class SongRepository {
  factory SongRepository(Dio dio) = _SongRepository;

  @GET(API.getSongsById)
  Future<SongModelV2> getSong({
    @Path('id') required String songId,
  });
  @GET(API.getSongs)
  Future<List<SongOverview>> getSongs({
    @Body() required SongFilter songFilter,
  });

  @GET(API.savedSongs)
  Future<List<SongOverview>> getSavedSongs({
    @Path('userId') required String userId,
  });

  @POST(API.savedSongsWithUserId)
  Future<String> saveSong({
    @Path('songId') required String songId,
    @Path('userId') required String userId,
  });

  @DELETE(API.savedSongsWithUserId)
  Future<String> removeSavedSong({
    @Path('songId') required String songId,
    @Path('userId') required String userId,
  });
}
