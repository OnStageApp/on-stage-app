import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'songs_state.freezed.dart';

@freezed
class SongsState with _$SongsState {
  const factory SongsState({
    @Default([]) List<SongOverview> songs,
    @Default([]) List<SongOverview> savedSongs,
    @Default([]) List<SongOverview> filteredSongs,
    @Default(false) bool isLoadingWithShimmer,
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(false) bool hasMore,
    @Default(0) int songsCount,
  }) = _SongsState;
}
