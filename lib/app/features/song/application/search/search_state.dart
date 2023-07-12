import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/song_model.dart';

class SearchState extends Equatable {
  const SearchState({
    this.songs,
    this.songsCount = 0,
    this.searchText,
    this.loadingAdventures = false,
  });

  final List<Song>? songs;
  final int songsCount;
  final String? searchText;
  final bool loadingAdventures;

  @override
  List<Object> get props => [];

  SearchState copyWith({
    List<Song>? songs,
    int? songsCount,
    String? searchText,
    bool? loadingAdventures,
  }) {
    return SearchState(
      songs: songs ?? this.songs,
      songsCount: songsCount ?? this.songsCount,
      searchText: searchText ?? this.searchText,
      loadingAdventures: loadingAdventures ?? this.loadingAdventures,
    );
  }
}
