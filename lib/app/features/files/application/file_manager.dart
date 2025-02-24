import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> openDocument(SongFile file, BuildContext context) async {
    try {
      _setLoading(file.id, true);
      _clearError(file.id);

      final documentUrl = await _ref
          .read(songFilesNotifierProvider.notifier)
          .getDocument(file.songId, file.id);

      if (documentUrl == null) {
        _setError(file.id, 'Failed to retrieve document URL');
        return;
      }

      // Caching the file based on its type
      final cachedFilePath = await _cacheFile(
        documentUrl,
        file.id,
        file.name,
        file.fileType, // Pass file type to handle PDFs separately
      );

      if (cachedFilePath == null) {
        _setError(file.id, 'Failed to cache file');
        return;
      }
      if (!context.mounted) return;

      await _openWithSystemViewer(cachedFilePath);
    } catch (e) {
      _setError(file.id, 'Error opening document: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open file: $e')),
        );
      }
    } finally {
      _setLoading(file.id, false);
    }
  }

  Future<void> openPDF(SongFile songFile, BuildContext context) async {
    try {
      final fileUrl = await _ref
              .read(songFilesNotifierProvider.notifier)
              .getDocument(songFile.songId, songFile.id) ??
          '';
      if (!context.mounted) return;
      await context.pushNamed(
        AppRoute.pdfPreview.name,
        extra: [fileUrl],
        queryParameters: {'initialIndex': '0', 'isLocalFile': 'true'},
      );
    } catch (e) {
      debugPrint('Error opening PDF: $e');
      throw Exception('Failed to open PDF file: $e');
    }
  }

  Future<void> _openWithSystemViewer(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      debugPrint('OpenFile result: $result');

      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error opening file with system viewer: $e');
      throw Exception('Failed to open file with system viewer: $e');
    }
  }

  // Cache file for both general files and PDFs
  Future<String?> _cacheFile(
    String url,
    String fileId,
    String fileName,
    FileTypeEnum fileType,
  ) async {
    try {
      // Create cache directory if needed
      final appDir = await getApplicationCacheDirectory();
      final fileDir = Directory('${appDir.path}/documents');
      if (!fileDir.existsSync()) {
        await fileDir.create(recursive: true);
      }

      // Determine the file extension based on file type
      final extension =
          fileType == FileTypeEnum.pdf ? 'pdf' : fileName.split('.').last;
      final cachedFilePath = '${fileDir.path}/$fileId.$extension';
      final cachedFile = File(cachedFilePath);

      // Download the file if it doesn't exist in cache
      if (!cachedFile.existsSync()) {
        final response = await http.get(Uri.parse(url));
        await cachedFile.writeAsBytes(response.bodyBytes);
        debugPrint('File downloaded to: $cachedFilePath');
      } else {
        debugPrint('Using cached file: $cachedFilePath');
      }

      return cachedFilePath;
    } catch (e) {
      debugPrint('Error caching file: $e');
      return null;
    }
  }

  Future<void> cleanupCache({int maxAgeInDays = 3}) async {
    try {
      final appDir = await getApplicationCacheDirectory();
      final fileDir = Directory('${appDir.path}/documents');

      if (fileDir.existsSync()) {
        final now = DateTime.now();
        await for (final entity in fileDir.list()) {
          if (entity is File) {
            final fileStat = entity.statSync();
            final fileAge = now.difference(fileStat.modified);

            if (fileAge.inDays > maxAgeInDays) {
              await entity.delete();
              debugPrint('Deleted old cached file: ${entity.path}');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up cache: $e');
    }
  }

  void _setLoading(String fileId, bool isLoading) {
    state = state.copyWith(
      loadingFiles: {...state.loadingFiles, fileId: isLoading},
    );
  }

  void _setError(String fileId, String error) {
    state = state.copyWith(
      errorMessages: {...state.errorMessages, fileId: error},
    );
  }

  void _clearError(String fileId) {
    final newErrors = {...state.errorMessages}..remove(fileId);
    state = state.copyWith(errorMessages: newErrors);
  }
}

final fileManagerProvider =
    StateNotifierProvider<FileManagerNotifier, FileManagerState>((ref) {
  return FileManagerNotifier(ref);
});
