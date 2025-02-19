import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/files/application/song_files_state.dart';
import 'package:on_stage_app/app/features/files/data/song_files_repository.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_files_notifier.g.dart';

@riverpod
class SongFilesNotifier extends _$SongFilesNotifier {
  SongFilesRepository get _repository => ref.read(songFilesRepoProvider);
  AudioController get _audioController =>
      ref.read(audioControllerProvider.notifier);

  @override
  SongFilesState build() => const SongFilesState();

  Future<void> getSongFiles() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final files = [
        const SongFile(
          id: '1',
          songId: '1',
          teamId: '1',
          name: 'ana are mere',
          url: 'http://ice1.somafm.com/groovesalad-128-mp3',
          size: 100,
          fileType: FileTypeEnum.audio,
        ),
        const SongFile(
          id: '5',
          songId: '1',
          teamId: '1',
          name: 'asdasd.pdf',
          url:
              'https://mfbinternationaldmcc.com/eng/files/katalog/qir0o375DUumvU0SjJGm.pdf',
          size: 200,
          fileType: FileTypeEnum.pdf,
        ),
        const SongFile(
          id: '6',
          songId: '1',
          teamId: '1',
          name: 'afdsanaare.pdf',
          url: 'https://www.sldttc.org/allpdf/21583473018.pdf',
          size: 200,
          fileType: FileTypeEnum.pdf,
        ),
        const SongFile(
          id: '2',
          songId: '1',
          teamId: '1',
          name: 'anaare.pdf',
          url:
              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          size: 200,
          fileType: FileTypeEnum.pdf,
        ),
        const SongFile(
          id: '3',
          songId: '1',
          teamId: '1',
          name: 'ana  pere',
          url: 'http://ice1.somafm.com/groovesalad-128-mp3',
          size: 200,
          fileType: FileTypeEnum.audio,
        ),
      ];
      // final songs = await _repository.getSongFiles();
      state = state.copyWith(songFiles: files);
    } catch (e) {
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
      url: file.path ?? '',
      size: file.size,
      fileType: fileType,
    );

    // Simply add the new file to the state.
    state = state.copyWith(songFiles: [...state.songFiles, newFile]);
  }

  Future<String> getUploadUrl(String fileName, int fileSize) async {
    try {
      return await _repository.getUploadUrl({
        'fileName': fileName,
        'fileSize': fileSize,
      });
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    }
  }

  Future<void> deleteSongFile(String id) async {
    try {
      await _repository.deleteSongFile(id);
      state = state.copyWith(
        songFiles: state.songFiles.where((song) => song.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<String> getStreamUrl(String id) async {
    try {
      return await _repository.getStreamUrl(id);
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    }
  }

  Future<void> openAudioFile(SongFile file) async {
    await _audioController.openFile(file);
  }

  Future<List<String>> getLocalPdfPathsForDocument(SongFile file) async {
    // Gather all PDF files from state.
    final allFiles =
        state.songFiles; // Assuming your state has a songFiles list.
    final pdfFiles =
        allFiles.where((f) => f.name.toLowerCase().endsWith('.pdf')).toList();

    final pdfPaths = <String>[];
    for (final pdf in pdfFiles) {
      String filePath;
      final localFile = File(pdf.url);
      final exists = localFile.existsSync();
      if (exists) {
        filePath = pdf.url;
      } else {
        try {
          final response = await http.get(Uri.parse(pdf.url));
          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            final tempDir = await getTemporaryDirectory();
            filePath = '${tempDir.path}/${pdf.name}';
            final tempFile = File(filePath);
            await tempFile.writeAsBytes(bytes);
          } else {
            continue; // Skip if download fails.
          }
        } catch (e) {
          logger.e('Error downloading ${pdf.name}: $e');
          continue;
        }
      }
      pdfPaths.add(filePath);
    }
    return pdfPaths;
  }
}
