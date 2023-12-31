import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

part 'song_model.freezed.dart';
part 'song_model.g.dart';

@Freezed()
class SongModel with _$SongModel {
  const factory SongModel({
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
  }) = _SongModel;

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);
}
