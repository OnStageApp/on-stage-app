import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SearchState extends Equatable {
  const SearchState({
    this.songs = const [],
    this.songsCount = 0,
  });

  final List<Song> songs;
  final int songsCount;

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
    );
  }
}
