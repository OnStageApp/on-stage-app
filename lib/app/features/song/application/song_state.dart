import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SongState extends Equatable {
  const SongState({
    this.songs = const [],
    this.filteredSongs = const [],
  });

  final List<SongModel> songs;
  final List<SongModel> filteredSongs;

  @override
  List<Object> get props => [
        songs,
        filteredSongs,
      ];

  SongState copyWith({
    List<SongModel>? songs,
    List<SongModel>? filteredSongs,
  }) {
    return SongState(
      songs: songs ?? this.songs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
    );
  }
}
