import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

class ArtistState extends Equatable {
  const ArtistState({
    this.artist = const [],
    this.isLoading = false,
  });

  final List<Artist> artist;

  final bool isLoading;

  @override
  List<Object> get props => [
        artist,
      ];

  ArtistState copyWith({
    List<Artist>? artists,
    List<Artist>? filteredArtists,
    bool? isLoading,
  }) {
    return ArtistState(
      artist: artist ?? this.artist,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
