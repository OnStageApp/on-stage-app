import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';
import 'package:on_stage_app/app/features/song/domain/models/tempo_filter.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required bool isFocused,
    required String text,
    ThemeEnum? themeFilter,
    Artist? artistFilter,
    bool? teamFilter,
    TempoFilter? tempoFilter,
  }) = _SearchState;

  const SearchState._();

  SongFilter toSongFilter() {
    return SongFilter(
      search: text.isNotEmpty ? text : null,
      artistId: artistFilter?.id,
      theme: themeFilter,
      tempoRange: tempoFilter,
      includeOnlyTeamSongs: teamFilter,
    );
  }
}
