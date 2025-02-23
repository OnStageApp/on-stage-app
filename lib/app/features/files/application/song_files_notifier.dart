import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/files/application/song_files_state.dart';
import 'package:on_stage_app/app/features/files/data/song_files_repository.dart';
import 'package:on_stage_app/app/features/files/data/song_files_upload_repository.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_files_notifier.g.dart';

@riverpod
class SongFilesNotifier extends _$SongFilesNotifier {
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  SongFilesRepository get _repository => ref.read(songFilesRepoProvider);
  SongFilesUploadRepository get _uploadRepository =>
      ref.read(songFilesUploadRepoProvider);
  AudioController get _audioController =>
      ref.read(audioControllerProvider.notifier);
  AmazonS3Notifier get _amazonS3Notifier =>
      ref.read(amazonS3NotifierProvider.notifier);
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

  Future<void> addSongFile(PlatformFile file) async {
    final extension = file.extension?.toLowerCase() ?? '';
    // Determine file type.
    final fileType = (['mp3', 'wav', 'aac', 'm4a', 'caf'].contains(extension))
        ? FileTypeEnum.audio
        : (extension == 'pdf')
            ? FileTypeEnum.pdf
            : FileTypeEnum.other;

    final newFile = SongFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      songId: '1',
      teamId: '1',
      name: file.name,
      size: file.size,
      fileType: fileType,
    );

    // Simply add the new file to the state.
    state = state.copyWith(songFiles: [...state.songFiles, newFile]);
  }

  Future<void> uploadFile(PlatformFile platformFile, String songId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final mimeType =
          lookupMimeType(platformFile.path!) ?? 'application/octet-stream';

      final multi = await MultipartFile.fromFile(
        platformFile.path!,
        filename: platformFile.name,
        contentType: MediaType.parse(mimeType),
      );

      final uploadedFile =
          await _uploadRepository.uploadSongFile(songId, multi);

      // Add the uploaded file to state
      state = state.copyWith(
        songFiles: [...state.songFiles, uploadedFile],
        isLoading: false,
      );
    } catch (e) {
      logger.e('Error uploading file: $e');
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  Future<void> deleteSongFile(String id) async {
    try {
      // await _repository.deleteSongFile(id);
      state = state.copyWith(
        songFiles: state.songFiles.where((song) => song.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<String?> getStreamUrl(String id) async {
    try {
      // return await _repository.getStreamUrl(id);
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    }
    return null;
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
