import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/song/application/search/search_song_state.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SongSearchProvider extends Notifier<SearchState> {
  @override
  SearchState build() {
    return SearchState(
      songs: SongDummy.songs,
      songsCount: SongDummy.songs.length,
    );
  }

  Future<void> searchSongs({
    required String searchedText,
  }) async {
    if (searchedText.isNullEmptyOrWhitespace) {
      ref.invalidateSelf();
    }
    final searchedSongs = SongDummy.songs
        .where(
          (song) => song.title.toLowerCase().contains(
                searchedText,
              ),
        )
        .toList();
    state = state.copyWith(songs: searchedSongs);
    logger.i('searchedSongs: ${searchedSongs.length}');
  }
}

final searchSongProvider =
    NotifierProvider<SongSearchProvider, SearchState>(SongSearchProvider.new);
