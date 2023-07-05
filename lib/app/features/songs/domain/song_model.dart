import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_model.freezed.dart';
part 'song_model.g.dart';

@Freezed()
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    required String artist,
    required String album,
    required String albumArtUrl,
    required String youtubeId,
    required String genre,
    required String duration,
    required String year,
    required String lyrics,
    required String tab,
    required String key,
    required String capo,
    required String tuning,
    required String createdAt,
    required String updatedAt,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
