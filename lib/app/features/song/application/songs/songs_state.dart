import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

class SongsState extends Equatable {
  const SongsState({
    this.songs = const [],
    this.filteredSongs = const [],
    this.isLoading = false,
    this.isLoadingWithShimmer = false,
  });

  final List<SongOverview> songs;
  final List<SongOverview> filteredSongs;
  final bool isLoadingWithShimmer;
  final bool isLoading;

  @override
  List<Object> get props => [
        songs,
        isLoadingWithShimmer,
        filteredSongs,
      ];

  SongsState copyWith({
    List<SongOverview>? songs,
    List<SongOverview>? filteredSongs,
    bool? isLoading,
    bool? isLoadingWithShimmer,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingWithShimmer: isLoadingWithShimmer ?? this.isLoadingWithShimmer,
    );
  }
}
