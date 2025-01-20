import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_filter.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_request.dart';
import 'package:on_stage_app/app/features/artist/domain/models/get_all_artists_response.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'artist_repository.g.dart';

@RestApi()
abstract class ArtistRepository {
  factory ArtistRepository(Dio dio) = _ArtistRepository;

  @GET(API.artistsPaginated)
  Future<GetAllArtistsResponse> getArtists({
    @Body() ArtistFilter? filter,
    @Query('limit') int limit = 25,
    @Query('offset') int offset = 0,
  });

  @POST(API.artists)
  Future<Artist> addArtist(@Body() ArtistRequest artist);
}
