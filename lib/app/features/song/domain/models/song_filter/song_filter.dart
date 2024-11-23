import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tempo_filter.dart';

part 'song_filter.freezed.dart';
part 'song_filter.g.dart';

@freezed
class SongFilter with _$SongFilter {
  const factory SongFilter({
    String? artistId,
    String? search,
    GenreEnum? genre,
    ThemeEnum? theme,
    TempoFilter? tempoRange,
    bool? includeOnlyTeamSongs,
  }) = _SongFilter;

  factory SongFilter.fromJson(Map<String, dynamic> json) =>
      _$SongFilterFromJson(json);
}
