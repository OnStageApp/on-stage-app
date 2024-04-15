import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';

part 'song_model.freezed.dart';
part 'song_model.g.dart';

@Freezed()
class SongModel with _$SongModel {
  const factory SongModel({
    String? id,
    String? title,
    String? lyrics,
    int? bpm,
    String? key,
    SongKey? songKey,
    SongKey? originalKey,
    String? createdAt,
    String? updatedAt,
    String? artist,
    String? album,
    int? capo,
  }) = _SongModel;

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);
}
