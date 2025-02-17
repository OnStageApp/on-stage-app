import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/domain/combined_player_state.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart' as rx;

part 'audio_player_notifier.g.dart';

@riverpod
class AudioController extends _$AudioController {
  AudioPlayer? _player;
  StreamSubscription<CombinedPlayerState>? _playerSubscription;

  @override
  AudioPlayerState build() {
    // Clean up resources when the provider is disposed.
    ref.onDispose(() {
      _playerSubscription?.cancel();
      _player?.dispose();
    });
    return const AudioPlayerState();
  }

  Future<void> openFile(SongFile file) async {
    await _initializePlayer();

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
      );

      await _player!.setUrl(file.url);
      state = state.copyWith(status: AudioStatus.ready);
      await _player!.play();
    } catch (e) {
      state = state.copyWith(status: AudioStatus.error);
    }
  }

  Future<void> closeFile() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
    await _playerSubscription?.cancel();

    state = const AudioPlayerState();
  }

  void stopPlaying() {
    _player?.pause();
    state = state.copyWith(currentSongFile: null);
  }

  Future<void> loadAudio(String url) async {
    if (_player == null) {
      await _initializePlayer();
    }
    try {
      state = state.copyWith(status: AudioStatus.loading);
      await _player!.setUrl(url);
      state = state.copyWith(status: AudioStatus.ready);
    } catch (e) {
      state = state.copyWith(status: AudioStatus.error);
    }
  }

  Future<void> play() async {
    if (state.status == AudioStatus.ready) {
      await _player?.play();
    }
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> seek(Duration position) async {
    await _player?.seek(position);
  }

  Future<void> skipForward() async {
    if (_player != null) {
      final newPosition = state.position + const Duration(seconds: 10);
      final skipTo =
          newPosition < state.duration ? newPosition : state.duration;
      await _player?.seek(skipTo);
    }
  }

  Future<void> skipBackward() async {
    if (_player != null) {
      final newPosition = state.position - const Duration(seconds: 10);
      final skipTo = newPosition > Duration.zero ? newPosition : Duration.zero;
      await _player?.seek(skipTo);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _initializePlayer() async {
    // Prevent multiple initializations.
    if (_player != null) return;

    _player = AudioPlayer();
    state = state.copyWith(player: _player);

    // Combine streams in a type-safe manner.
    final combinedStream = rx.CombineLatestStream.combine4<Duration, Duration,
        Duration?, PlayerState, CombinedPlayerState>(
      _player!.positionStream,
      _player!.bufferedPositionStream,
      _player!.durationStream,
      _player!.playerStateStream,
      (position, bufferedPosition, duration, playerState) =>
          CombinedPlayerState(
        position: position,
        bufferedPosition: bufferedPosition,
        duration: duration ?? Duration.zero,
        isPlaying: playerState.playing,
      ),
    );

    // Listen to the combined stream and update the state.
    _playerSubscription = combinedStream.listen((combinedState) {
      state = state.copyWith(
        position: combinedState.position,
        bufferedPosition: combinedState.bufferedPosition,
        duration: combinedState.duration,
        isPlaying: combinedState.isPlaying,
      );
    });
  }
}
