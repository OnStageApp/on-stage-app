import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';

part 'audio_player_state.freezed.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {
  const factory AudioPlayerState({
    SongFile? currentSongFile,
    @Default(false) bool isPlaying,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    @Default(Duration.zero) Duration duration,
    @Default(AudioStatus.initial) AudioStatus status,
    AudioPlayer? player,
    String? errorMessage,
  }) = _AudioPlayerState;
}

enum AudioStatus { initial, loading, ready, error }
