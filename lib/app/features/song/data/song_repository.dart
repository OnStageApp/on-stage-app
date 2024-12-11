import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_page.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'song_repository.g.dart';

@RestApi()
abstract class SongRepository {
  factory SongRepository(Dio dio) = _SongRepository;

  @GET(API.getSongsById)
  Future<SongModelV2> getSong({
    @Path('id') required String songId,
  });

  @Deprecated('Use getSongsWithPagination instead')
  @GET(API.getSongs)
  Future<List<SongOverview>> getSongs({
    @Body() required SongFilter songFilter,
  });

  @GET(API.getSongsWithPagination)
  Future<SongOverviewPage> getSongsWithPagination({
    @Body() required SongFilter songFilter,
    @Query('offset') required int offset,
    @Query('limit') required int limit,
  });

  @GET(API.getSongsCount)
  Future<int> getSongsCount();

  @GET(API.savedSongs)
  Future<List<SongOverview>> getSavedSongs();

  @POST(API.savedSongsWithUserId)
  Future<String> saveFavoriteSong({
    @Path('songId') required String songId,
    @Path('userId') required String userId,
  });

  @POST(API.addSong)
  Future<SongModelV2> addSong({
    @Body() required SongRequest song,
  });

  @PUT(API.updateSongById)
  Future<SongModelV2> updateSong({
    @Path('id') required String id,
    @Body() required SongRequest song,
  });

  @DELETE(API.savedSongsWithUserId)
  Future<String> removeSavedSong({
    @Path('songId') required String songId,
    @Path('userId') required String userId,
  });
}
