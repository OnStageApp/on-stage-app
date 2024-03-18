import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SongState extends Equatable {
  const SongState({
    this.song,
    this.isLoading = false,
  });


  final SongModel? song;

  final bool isLoading;

  @override
  List<Object?> get props => [
    song,
    isLoading
  ];

  SongState copyWith({
    SongModel? song,
    bool? isLoading,
  }) {
    return SongState(
      song: song ?? this.song,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
