import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

part 'artists_state.freezed.dart';

@freezed
class ArtistsState with _$ArtistsState {
  const factory ArtistsState({
    @Default([]) List<Artist> artists,
    @Default([]) List<Artist> filteredArtists,
    @Default(false) bool isLoading,
    @Default(true) bool hasMore,
    String? error,
  }) = _ArtistsState;
}
