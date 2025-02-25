import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/files/application/song_files_state.dart';
import 'package:on_stage_app/app/features/files/application/upload_manager/uploads_manager.dart';
import 'package:on_stage_app/app/features/files/data/song_files_repository.dart';
import 'package:on_stage_app/app/features/files/data/song_files_upload_repository.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/domain/update_song_file_request.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_files_notifier.g.dart';

@riverpod
class SongFilesNotifier extends _$SongFilesNotifier {
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  SongFilesRepository get _repository => ref.read(songFilesRepoProvider);
  SongFilesUploadRepository get _uploadRepository =>
      // ignore: avoid_manual_providers_as_generated_provider_dependency
      ref.read(songFilesUploadRepoProvider);
  AudioController get _audioController =>
      ref.read(audioControllerProvider.notifier);
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
      // First update backend
      final request = UpdateSongFileRequest(name: newName);
      await _repository.updateSongFile(fileId, request);

      // Then update state
      final updatedFiles = state.songFiles.map((file) {
        if (file.id == fileId) {
          return file.copyWith(name: newName);
        }
        return file;
      }).toList();

      state = state.copyWith(songFiles: updatedFiles);
    } catch (e) {
      logger.e('Error renaming file: $e');
      state = state.copyWith(error: e);
    }
  }

  Future<void> uploadFile(PlatformFile platformFile, String songId) async {
    try {
      // Create uploading file model
      final upFile = UploadingFile(
        id: platformFile.name,
        name: platformFile.name,
        fileType: FileTypeEnum.fromExtension(platformFile.extension ?? ''),
        size: platformFile.size,
      );

      // Mark file as uploading
      _uploadsManager.startUpload(upFile);

      state = state.copyWith(error: null);

      // Prepare the file for upload
      final mimeType =
          lookupMimeType(platformFile.path!) ?? 'application/octet-stream';

      final multi = await MultipartFile.fromFile(
        platformFile.path!,
        filename: platformFile.name,
        contentType: MediaType.parse(mimeType),
      );

      // Perform the actual upload
      final uploadedFile =
          await _uploadRepository.uploadSongFile(songId, multi);

      // Mark upload as successful
      await _uploadsManager.markUploadSuccess(upFile);

      // Update the state with the new file
      state = state.copyWith(
        songFiles: [...state.songFiles, uploadedFile],
      );
    } catch (e) {
      logger.e('Error uploading file: $e');

      // Convert error to user-friendly message
      final errorMessage = e.toString();
      final cleanError = errorMessage.length > 50
          ? '${errorMessage.substring(0, 50)}...'
          : errorMessage;

      // Mark upload as failed
      _uploadsManager.markUploadError(
        platformFile.name,
        cleanError,
        platformFile.extension,
        platformFile.size,
      );

      state = state.copyWith(error: e, isLoading: false);
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

  Future<void> openAudioFile(SongFile file, String songId) async {
    final presignedUrl = await _repository.getPresignedUrl(songId, file.id);
    await _audioController.openFile(file, presignedUrl);
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
}
