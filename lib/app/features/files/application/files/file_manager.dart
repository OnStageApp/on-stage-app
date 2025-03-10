import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/files/application/cache/caching_service.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/multi_pdf_preview_screen.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class FileManagerState {
  FileManagerState({
    this.loadingFiles = const {},
    this.errorMessages = const {},
  });
  final Map<String, bool> loadingFiles;
  final Map<String, String?> errorMessages;

  bool isLoading(String fileId) => loadingFiles[fileId] ?? false;
  String? getError(String fileId) => errorMessages[fileId];

  FileManagerState copyWith({
    Map<String, bool>? loadingFiles,
    Map<String, String?>? errorMessages,
  }) {
    return FileManagerState(
      loadingFiles: loadingFiles ?? this.loadingFiles,
      errorMessages: errorMessages ?? this.errorMessages,
    );
  }
}

class FileManagerNotifier extends StateNotifier<FileManagerState> {
  FileManagerNotifier(this._ref) : super(FileManagerState());
  final Ref _ref;

  AudioController get _audioController =>
      _ref.read(audioControllerProvider.notifier);

  CachingService get _cachingService => _ref.read(cachingServiceProvider);

  Future<void> openFile(SongFile file, BuildContext context) async {
    try {
      _setLoading(file.id, true);
      _clearError(file.id);

      if (file.fileType == FileTypeEnum.link) {
        if (file.link.isNullEmptyOrWhitespace) {
          _setError(file.id, 'Link URL is empty');
          return;
        }
        await _openLink(file.link!);

        return;
      }
      String? s3FileUrl;
      final cachedFileUrl = await _cachingService.checkCache(
        file.id,
        file.name,
        file.fileExtension ?? '',
        file.fileType,
      );
      logger.i('File is cached: ${cachedFileUrl.isNotNullEmptyOrWhitespace}');

      if (cachedFileUrl.isNullEmptyOrWhitespace) {
        s3FileUrl = await _ref
            .read(songFilesNotifierProvider.notifier)
            .getDocument(file.songId, file.id);

        if (s3FileUrl == null) {
          _setError(file.id, 'Failed to retrieve file URL');
          return;
        }
        logger.i('Fetched file URL');
      }

      final fileToOpen = cachedFileUrl.isNotNullEmptyOrWhitespace
          ? cachedFileUrl
          : await _cacheFile(file, s3FileUrl);

      if (fileToOpen != null) {
        if (!context.mounted) return;
        unawaited(_openFileBasedOnType(file, fileToOpen, context));
      }
    } catch (e) {
      _setError(file.id, 'Error opening file: $e');
      if (!context.mounted) return;
      _showErrorSnackbar(context, 'Failed to open file: $e');
    } finally {
      _setLoading(file.id, false);
    }
  }

  Future<String?> _cacheFile(SongFile file, String? fileUrl) async {
    final cachedFile = await _cachingService.cacheFile(
      fileUrl!,
      file.id,
      file.name,
      file.fileExtension ?? '',
      file.fileType,
    );

    if (cachedFile == null) {
      _setError(file.id, 'Failed to cache file: ${file.name}');
      return null;
    }

    return cachedFile;
  }

  Future<void> _openFileBasedOnType(
    SongFile file,
    String cachedFilePath,
    BuildContext context,
  ) async {
    if (file.fileType == FileTypeEnum.audio) {
      await _openAudioFile(file, cachedFilePath);
    } else if (file.fileType == FileTypeEnum.pdf) {
      await _openPDFFile(cachedFilePath, context);
    } else {
      await _openDocumentFile(cachedFilePath);
    }
    logger.i('Opened file: ${file.name}');
  }

  Future<void> _openAudioFile(SongFile file, String cachedFilePath) async {
    await _audioController.openFile(file, cachedFilePath);
  }

  Future<void> _openPDFFile(String cachedFilePath, BuildContext context) async {
    try {
      if (!context.mounted) return;
      await MultiPdfPreviewDialog.show(
        context: context,
        filePaths: [cachedFilePath],
      );
    } catch (e) {
      logger.e('Error opening PDF: $e');
      throw Exception('Failed to open PDF file: $e');
    }
  }

  Future<void> _openDocumentFile(String cachedFilePath) async {
    try {
      await OpenFile.open(cachedFilePath);
    } catch (e) {
      throw Exception('Failed to open document: $e');
    }
  }

  // Error handling improvements
  void _setError(String fileId, String error) {
    state = state.copyWith(
      errorMessages: {...state.errorMessages, fileId: error},
    );
  }

  void _clearError(String fileId) {
    final newErrors = {...state.errorMessages}..remove(fileId);
    state = state.copyWith(errorMessages: newErrors);
  }

  void _setLoading(String fileId, bool isLoading) {
    state = state.copyWith(
      loadingFiles: {...state.loadingFiles, fileId: isLoading},
    );
  }

  // Show error messages in snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}

final fileManagerProvider =
    StateNotifierProvider<FileManagerNotifier, FileManagerState>((ref) {
  return FileManagerNotifier(ref);
});
