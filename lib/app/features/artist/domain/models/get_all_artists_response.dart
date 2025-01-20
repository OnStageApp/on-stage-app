import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

part 'get_all_artists_response.freezed.dart';
part 'get_all_artists_response.g.dart';

@Freezed()
class GetAllArtistsResponse with _$GetAllArtistsResponse {
  const factory GetAllArtistsResponse({
    required List<Artist> artists,
    required bool hasMore,
  }) = _GetAllArtistsResponse;

  factory GetAllArtistsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllArtistsResponseFromJson(json);
}
