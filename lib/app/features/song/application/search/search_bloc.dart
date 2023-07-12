import 'package:bloc/bloc.dart';
import 'package:on_stage_app/app/features/song/application/search/search_event.dart';
import 'package:on_stage_app/app/features/song/application/search/search_state.dart';
import 'package:on_stage_app/app/features/song/domain/song_model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.songs}) : super(const SearchState()) {
    on<InitSearch>(_handleInitSearch);
    on<SearchSongs>(_handleSearchSongs);
  }

  final List<Song> songs;

  Future<void> _handleInitSearch(
    InitSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        songs: [],
        songsCount: 0,
      ),
    );
  }

  Future<void> _handleSearchSongs(
    SearchSongs event,
    Emitter<SearchState> emit,
  ) async {
    final searchedSongs = songs
        .where(
          (song) => song.title.toLowerCase().contains(
                event.searchedText!,
              ),
        )
        .toList();
    state.copyWith(
      songs: searchedSongs,
      songsCount: searchedSongs.length,
    );
  }
}
