import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/files/domain/file_error_info.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';

part 'uploads_manager_state.freezed.dart';

@freezed
class UploadsManagerState with _$UploadsManagerState {
  const factory UploadsManagerState({
    @Default({}) Set<UploadingFile> uploadingFiles,
    @Default({}) Set<UploadingFile> successFiles,
    @Default({}) Set<FileErrorInfo> errorFiles,
  }) = _UploadsState;
}
