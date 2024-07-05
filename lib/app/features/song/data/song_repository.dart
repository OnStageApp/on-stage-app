import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'song_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class SongRepository {
  factory SongRepository(Dio dio) = _SongRepository;

  @GET(API.getSongs)
  Future<List<SongOverview>> getSongs({
    @Query('search') String? search,
  });
}
