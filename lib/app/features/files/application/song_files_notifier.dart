import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:on_stage_app/app/features/files/application/song_files_state.dart';
import 'package:on_stage_app/app/features/files/application/upload_manager/uploads_manager.dart';
import 'package:on_stage_app/app/features/files/data/song_files_repository.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/domain/update_song_file_request.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';
import 'package:on_stage_app/app/shared/data/error/error_model/validation_exception.dart';
import 'package:on_stage_app/app/shared/data/error/handlers/api_error_handler.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_files_notifier.g.dart';

const maxUploadSize = 52428800;

@riverpod
class SongFilesNotifier extends _$SongFilesNotifier {
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  SongFilesRepository get _repository => ref.read(songFilesRepoProvider);

  UploadsManager get _uploadsManager =>
      ref.read(uploadsManagerProvider.notifier);

  @override
  SongFilesState build() => const SongFilesState();

  Future<void> getSongFiles(String songId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final files = await _repository.getSongFiles(songId);
      state = state.copyWith(songFiles: files);
    } catch (e) {
      logger.e('Error getting song files: $e');
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> renameSongFile(String fileId, String newName) async {
    try {
      final updatedFiles = state.songFiles.map((file) {
        if (file.id == fileId) {
          return file.copyWith(name: newName);
        }
        return file;
      }).toList();

      state = state.copyWith(songFiles: updatedFiles);

      final request = UpdateSongFileRequest(name: newName);
      await _repository.updateSongFile(fileId, request);
    } catch (e) {
      logger.e('Error renaming file: $e');
      state = state.copyWith(
        songFiles: state.songFiles,
        error: e,
      );
    }
  }

  Future<void> uploadFile(PlatformFile platformFile, String songId) async {
    try {
      _validateFile(platformFile);
      final upFile = _prepareUpload(platformFile);

      if (platformFile.path == null) {
        throw Exception('File path is required for uploadFile method');
      }

      final tempFile = File(platformFile.path!);

      final uploadedFile = await _performUpload(songId, tempFile, upFile);

      _updateState(uploadedFile);
    } catch (e, s) {
      _handleUploadError(e, s, platformFile);
    }
  }

  Future<void> uploadDroppedFile(
    PlatformFile platformFile,
    String songId,
  ) async {
    File? tempFile;
    try {
      _validateFile(platformFile);
      final upFile = _prepareUpload(platformFile);

      if (platformFile.bytes == null) {
        throw Exception('File bytes are required for uploadDroppedFile method');
      }

      final tempDir = await getTemporaryDirectory();

      final sanitizedName =
          platformFile.name.replaceAll(RegExp(r'[^\w\s\.\-]'), '_');
      tempFile = File(p.join(tempDir.path, sanitizedName));

      await tempFile.writeAsBytes(platformFile.bytes!);

      final uploadedFile = await _performUpload(songId, tempFile, upFile);

      _updateState(uploadedFile);
    } catch (e, s) {
      _handleUploadError(e, s, platformFile);
    } finally {
      if (tempFile != null && tempFile.existsSync()) {
        try {
          await tempFile.delete();
        } catch (e) {
          logger.e('Error deleting temporary file: $e');
        }
      }
    }
  }

  Future<void> deleteSongFile(String id) async {
    try {
      await _repository.deleteSongFile(id);

      state = state.copyWith(
        songFiles: state.songFiles.where((song) => song.id != id).toList(),
      );
    } catch (e) {
      logger.e('Error deleting file: $e');
      state = state.copyWith(error: e);
    }
  }

  Future<String?> getDocument(
    String songId,
    String fileId,
  ) async {
    try {
      final presignedUrl = await _repository.getPresignedUrl(songId, fileId);
      if (presignedUrl.isNullEmptyOrWhitespace) {
        throw Exception('Presigned URL is null or empty');
      }
      return presignedUrl;
    } catch (e) {
      logger.e('Error fetching PDF document URL: $e');
      return null;
    }
  }

  // Helper methods for common functionality
  void _validateFile(PlatformFile file) {
    if (file.size > maxUploadSize) {
      throw ValidationException(
        message: 'File size exceeds the maximum allowed size of 50MB',
        technicalDetails: 'File size: ${file.size}, Max size: $maxUploadSize',
      );
    }
  }

  UploadingFile _prepareUpload(PlatformFile file) {
    final upFile = UploadingFile(
      id: file.name,
      name: file.name,
      fileType: FileTypeEnum.fromExtension(file.extension ?? ''),
      size: file.size,
    );

    _uploadsManager.startUpload(upFile);
    state = state.copyWith(error: null);

    return upFile;
  }

  Future<SongFile> _performUpload(
    String songId,
    File multi,
    UploadingFile upFile,
  ) async {
    // Perform the actual upload
    final uploadedFile = await _repository.uploadSongFile(songId, multi);

    // Mark upload as successful
    await _uploadsManager.markUploadSuccess(upFile);

    return uploadedFile;
  }

  void _updateState(SongFile uploadedFile) {
    state = state.copyWith(
      songFiles: [...state.songFiles, uploadedFile],
    );
  }

  void _handleUploadError(
    Object error,
    StackTrace stackTrace,
    PlatformFile platformFile,
  ) {
    final errorResult = ApiErrorHandler.handleError(error, stackTrace);

    _uploadsManager.markUploadError(
      platformFile.name,
      errorResult.message,
      platformFile.extension,
      platformFile.size,
    );

    state = state.copyWith(error: error, isLoading: false);
  }
}
