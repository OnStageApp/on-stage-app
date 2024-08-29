import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_filter.freezed.dart';
part 'song_filter.g.dart';

@freezed
class SongFilter with _$SongFilter {
  const factory SongFilter({
    String? artistId,
    String? search,
    String? genres,
    // KeysEnum key,
  }) = _SongFilter;

  factory SongFilter.fromJson(Map<String, dynamic> json) =>
      _$SongFilterFromJson(json);
}
