import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';

part 'file_error_info.freezed.dart';
part 'file_error_info.g.dart';

@freezed
class FileErrorInfo with _$FileErrorInfo {
  const factory FileErrorInfo({
    required UploadingFile file,
    required String errorMessage,
  }) = _FileErrorInfo;

  factory FileErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$FileErrorInfoFromJson(json);
}
