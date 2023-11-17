import 'package:on_stage_app/app/features/song/application/song_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_provider.g.dart';

@Riverpod(keepAlive: true)
class SongNotifier extends _$SongNotifier {
  @override
  SongState build() {
    return const SongState();
  }

  Future<void> init() async {
    if (state.songs.isNotEmpty) {
      return;
    }
    logger.i('init song provider state');
    await getSongs();
  }

  Future<void> getSongs() async {
    if (state.songs.isNotEmpty) {
      state = state.copyWith(filteredSongs: state.songs);
      return;
    }
    ref.read(loadingProvider.notifier).state = true;
    final songs = await ref.read(songRepositoryProvider.notifier).fetchSongs();
    ref.read(loadingProvider.notifier).state = false;
    state = state.copyWith(songs: songs, filteredSongs: songs);
  }

  Future<void> searchSongs({
    required String searchedText,
  }) async {
    if (searchedText.isNotNullEmptyOrWhitespace) {
      final searchedSongs = state.songs
          .where(
            (song) => song.title.toLowerCase().contains(
                  searchedText,
                ),
          )
          .toList();
      state = state.copyWith(filteredSongs: searchedSongs);
      logger.i('searched songs: ${searchedSongs.length}');
    } else {
      await getSongs();
    }
  }
}
