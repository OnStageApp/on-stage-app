import 'package:on_stage_app/app/features/files/application/upload_manager/uploads_manager_state.dart';
import 'package:on_stage_app/app/features/files/domain/file_error_info.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uploads_manager.g.dart';

@riverpod
class UploadsManager extends _$UploadsManager {
  @override
  UploadsManagerState build() {
    return const UploadsManagerState();
  }

  void startUpload(UploadingFile file) {
    final uploadingFiles = {...state.uploadingFiles};
    final errorFiles = {...state.errorFiles}
      ..removeWhere((err) => err.file.id == file.id);


    uploadingFiles.add(file);

    state = state.copyWith(
      uploadingFiles: uploadingFiles,
      errorFiles: errorFiles,
    );

    logger.i('File ${file.name} added to uploading queue');
  }

  Future<void> markUploadSuccess(UploadingFile file) async {
    final uploadingFiles = {...state.uploadingFiles};
    final successFiles = {...state.successFiles};

    uploadingFiles.removeWhere((upFile) => upFile.id == file.id);

    successFiles.add(file);

    state = state.copyWith(
      uploadingFiles: uploadingFiles,
      successFiles: successFiles,
    );

    logger.i('File ${file.name} uploaded successfully');

    Future.delayed(const Duration(seconds: 1), () {
      final updatedSuccessFiles = {...state.successFiles}
        ..removeWhere((upFile) => upFile.id == file.id);

      state = state.copyWith(successFiles: updatedSuccessFiles);
      logger.i('File ${file.name} removed from success display');
    });
  }

  void markUploadError(
    String fileId,
    String errorMessage,
    String? extension,
    int size,
  ) {
    final uploadingFiles = {...state.uploadingFiles};
    final errorFiles = {...state.errorFiles};

    // Remove from uploading files
    uploadingFiles.removeWhere((file) => file.id == fileId);

    // Create file model
    final upFile = UploadingFile(
      id: fileId,
      name: fileId,
      fileType: FileTypeEnum.fromExtension(extension ?? ''),
      size: size,
    );

    // Remove existing error for this file if present
    errorFiles
      ..removeWhere((err) => err.file.id == fileId)

      // Add new error info
      ..add(
        FileErrorInfo(
          file: upFile,
          errorMessage: errorMessage,
        ),
      );

    state = state.copyWith(
      uploadingFiles: uploadingFiles,
      errorFiles: errorFiles,
    );

    logger.e('File $fileId upload failed: $errorMessage');
  }

  void clearErrorFile(String fileId) {
    final errorFiles = {...state.errorFiles}
      ..removeWhere((err) => err.file.id == fileId);

    state = state.copyWith(errorFiles: errorFiles);
    logger.i('Error cleared for file $fileId');
  }

  void clearAllErrors() {
    state = state.copyWith(errorFiles: {});
    logger.i('All error files cleared');
  }

  void cancelUpload(String fileId) {
    final uploadingFiles = {...state.uploadingFiles}
      ..removeWhere((file) => file.id == fileId);

    state = state.copyWith(uploadingFiles: uploadingFiles);
    logger.i('Upload for file $fileId marked as cancelled');
  }
}
