import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_filter.freezed.dart';
part 'artist_filter.g.dart';

@Freezed()
class ArtistFilter with _$ArtistFilter {
  const factory ArtistFilter({
    required String search,
  }) = _ArtistFilter;

  factory ArtistFilter.fromJson(Map<String, dynamic> json) =>
      _$ArtistFilterFromJson(json);
}
