import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SongsState extends Equatable {
  const SongsState({
    this.songs = const [],
    this.filteredSongs = const [],
    this.isLoading = false,
  });

  final List<SongModel> songs;
  final List<SongModel> filteredSongs;

  final bool isLoading;

  @override
  List<Object> get props => [
        songs,
        filteredSongs,
      ];

  SongsState copyWith({
    List<SongModel>? songs,
    List<SongModel>? filteredSongs,
    bool? isLoading,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
