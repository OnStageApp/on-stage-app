import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
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
    bool? isLibrary,
  }) = _SearchState;

  const SearchState._();

  SongFilter toSongFilter() {
    return SongFilter(
      search: text.isNotEmpty ? text : null,
      artistId: artistFilter?.id,
      theme: themeFilter,
      tempoRange: tempoFilter,
      includeOnlyTeamSongs: teamFilter,
      isLibrary: isLibrary,
    );
  }

  List<SearchFilter> get activeFilters {
    return [
      if (artistFilter != null)
        SearchFilter(
          type: SearchFilterEnum.artist,
          value: artistFilter!.name,
        ),
      if (themeFilter != null)
        SearchFilter(
          type: SearchFilterEnum.theme,
          value: themeFilter!.title,
        ),
      if (teamFilter != null)
        SearchFilter(
          type: SearchFilterEnum.team,
          value: teamFilter! ? 'Team Songs' : 'All Songs',
        ),
      if (tempoFilter != null) _buildTempoFilter,
    ];
  }

  SearchFilter get _buildTempoFilter {
    final min = tempoFilter?.min;
    final max = tempoFilter?.max;

    final value = switch ((min, max)) {
      (null, null) => '',
      (null, final max) => 'Up to $max',
      (final min, null) => 'From $min',
      (final min, final max) => '$min - $max',
    };

    return SearchFilter(
      type: SearchFilterEnum.tempo,
      value: value,
    );
  }
}
