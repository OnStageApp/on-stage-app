import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/artist_model.dart';

part 'song_model.freezed.dart';
part 'song_model.g.dart';

@Freezed()
class Song with _$Song {
  const factory Song({
    required int id,
    required String title,
    required String lyrics,
    required String tab,
    required String key,
    required String createdAt,
    required String updatedAt,
    required Artist artist,
    String? album,
    int? capo,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
