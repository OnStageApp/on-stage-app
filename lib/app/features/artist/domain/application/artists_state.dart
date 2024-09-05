import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

class ArtistsState extends Equatable {
  const ArtistsState({
    this.artists = const [],
    this.filteredArtists = const [],
    this.isLoading = false,
  });

  final List<Artist> artists;
  final List<Artist> filteredArtists;

  final bool isLoading;

  @override
  List<Object> get props => [
    artists,
    filteredArtists,
  ];

  ArtistsState copyWith({
    List<Artist>? artists,
    List<Artist>? filteredArtists,
    bool? isLoading,
  }) {
    return ArtistsState(
      artists: artists ?? this.artists,
      filteredArtists: filteredArtists ?? this.filteredArtists,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
