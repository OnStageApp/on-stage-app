import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';

part 'uploading_file.freezed.dart';
part 'uploading_file.g.dart';

@freezed
class UploadingFile with _$UploadingFile {
  const factory UploadingFile({
    required String id,
    required String name,
    required FileTypeEnum fileType,
    required int size,
  }) = _UploadingFile;

  factory UploadingFile.fromJson(Map<String, dynamic> json) =>
      _$UploadingFileFromJson(json);
}
