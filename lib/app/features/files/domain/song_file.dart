import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';

part 'song_file.freezed.dart';
part 'song_file.g.dart';

@freezed
class SongFile with _$SongFile {
  const factory SongFile({
    required String id,
    required String name,
    required String url,
    required String duration,
    required int size,
    required FileTypeEnum fileType,
  }) = _SongFile;

  factory SongFile.fromJson(Map<String, dynamic> json) =>
      _$SongFileFromJson(json);
}
