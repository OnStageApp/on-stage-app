import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongNotifier extends _$SongNotifier {
  @override
  SongState build() {
    return const SongState();
  }

  Future<void> init() async {
    if (state.song != null) {
      return;
    }
    logger.i('init song provider state');
  }

  Future<void> getSongById(String songId) async {
    state = state.copyWith(isLoading: true);
    final song =
    await ref.read(songRepositoryProvider.notifier).getSongById(songId);

    state = state.copyWith(currentSong: song, isLoading: false);

  }



}
