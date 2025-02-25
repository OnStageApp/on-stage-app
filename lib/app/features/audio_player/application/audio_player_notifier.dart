import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/domain/combined_player_state.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';
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

// Improve error handling with user-friendly messages
  Future<void> openFile(SongFile file, String presignedUrl) async {
    await _initializePlayer();

    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null, // Clear any previous errors
      );

      final audioSource = AudioSource.uri(
        Uri.parse(presignedUrl),
        tag: MediaItem(
          id: file.id,
          album: 'OnStage',
          title: file.name,
          artUri: artUri,
        ),
      );

      await _player!.setAudioSource(audioSource);

      state = state.copyWith(status: AudioStatus.ready);

      await _player!.play();
    } catch (e, stackTrace) {
      logger.e('Error opening file', e, stackTrace);

      // Provide a user-friendly error message
      var errorMessage = 'Unable to play audio file';
      if (e is PlayerException) {
        errorMessage = 'Playback error: Please try again';
      } else if (e is FormatException) {
        errorMessage = 'Invalid audio format';
      } else if (e is SocketException) {
        errorMessage = 'Network error: Please check your connection';
      }

      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: errorMessage,
      );
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
    // Update the UI state immediately to show where the user is seeking to
    state = state.copyWith(
      isSeeking: true,
      seekPosition: position,
    );

    // Perform the actual seek operation
    await _player?.seek(position);

    // After seeking completes, update the state
    state = state.copyWith(
      isSeeking: false,
    );
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

  Future<Uri> _getAssetArtUri(String assetPath) async {
    // Load the asset as bytes.
    final byteData = await rootBundle.load(assetPath);
    // Get a temporary directory.
    final tempDir = await getTemporaryDirectory();
    // Create a temporary file.
    final file = File('${tempDir.path}/logo_onstage.png');
    // Write the asset bytes to the file.
    await file.writeAsBytes(byteData.buffer.asUint8List());
    // Return the file URI.
    return Uri.file(file.path);
  }
}
