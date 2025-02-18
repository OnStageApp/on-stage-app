import 'package:file_picker/file_picker.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/files/application/song_files_state.dart';
import 'package:on_stage_app/app/features/files/data/song_files_repository.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
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
      final songs = [
        const SongFile(
          id: '1',
          name: 'ana are mere',
          url: 'http://ice1.somafm.com/groovesalad-128-mp3',
          size: 100,
          duration: '180',
          fileType: FileTypeEnum.audio,
        ),
        const SongFile(
          id: '2',
          name: 'ana are ',
          url: '',
          size: 200,
          duration: '180',
          fileType: FileTypeEnum.audio,
        ),
        const SongFile(
          id: '3',
          name: 'ana  pere',
          url: 'http://ice1.somafm.com/groovesalad-128-mp3',
          size: 200,
          duration: '180',
          fileType: FileTypeEnum.audio,
        ),
      ];
      // final songs = await _repository.getSongFiles();
      state = state.copyWith(songFiles: songs);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

    Future<void> addSongFile(PlatformFile file) async {
    final extension = file.extension?.toLowerCase() ?? '';
    // Determine file type
    final fileType = (['mp3', 'wav', 'aac', 'm4a', 'caf'].contains(extension))
        ? FileTypeEnum.audio
        : (['pdf', 'doc', 'docx', 'txt'].contains(extension))
            ? FileTypeEnum.document
            : FileTypeEnum.document;
    
    final newFile = SongFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: file.name,
      url: file.path ?? '',
      size: file.size,
      duration: '0', // duration not available until processed
      fileType: fileType,
    );

    // Simply add the new file to the state
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
}
