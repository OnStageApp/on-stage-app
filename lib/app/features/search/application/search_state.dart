import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required bool isFocused,
    required String text,
    GenreEnum? genreFilter,
    ThemeEnum? themeFilter,
    Artist? artistFilter,
    bool? teamFilter,
  }) = _SearchState;

  const SearchState._();

  SongFilter toSongFilter() {
    return SongFilter(
      search: text.isNotEmpty ? text : null,
      artistId: artistFilter?.id,
      genres: genreFilter?.name,
      includeOnlyTeamSongs: teamFilter,
    );
  }
}
