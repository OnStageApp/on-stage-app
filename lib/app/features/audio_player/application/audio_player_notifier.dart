import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/audio_handler/audio_handler.dart';
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
  StreamSubscription<dynamic>? _playerSubscription;
  StreamSubscription<dynamic>? _combinedSubscription;

  @override
  AudioPlayerState build() {
    final audioHandler = ref.watch(audioHandlerProvider);
    ref.onDispose(() {
      ref.onDispose(() {
        _playerSubscription?.cancel();
        _player?.dispose();
        audioHandler.stop();
      });
    });
    return const AudioPlayerState();
  }

  Future<void> openFile(
    SongFile file,
    String localUrl,
  ) async {
    await _initializePlayer();

    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null,
      );

      await _player!.setSourceDeviceFile(localUrl);
      final audioHandler = ref.watch(audioHandlerProvider);
      await audioHandler.updateMediaItem(
        MediaItem(
          id: file.id,
          album: 'OnStage',
          title: file.name,
          artUri: artUri,
        ),
      );
      state = state.copyWith(status: AudioStatus.ready);
      await _player!.resume();
      await ref.read(audioHandlerProvider).play();

      // ignore: avoid_manual_providers_as_generated_provider_dependency
    } catch (e, stackTrace) {
      logger.e(
        'Error opening file ${file.name}, path: $localUrl',
        e,
        stackTrace,
      );

      var errorMessage = 'Unable to play audio file';
      if (e is Exception) {
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

  Future<void> play() async {
    if (state.status == AudioStatus.ready) {
      unawaited(_player?.resume());
      await ref.read(audioHandlerProvider).play();
    }
  }

  Future<void> pause() async {
    await _player?.pause();
    await ref.read(audioHandlerProvider).pause();
  }

  Future<void> seek(Duration position) async {
    await _player?.seek(position);
  }

  Future<void> skipForward() async {
    await _skipBy(const Duration(seconds: 10));
  }

  Future<void> skipBackward() async {
    await _skipBy(const Duration(seconds: -10));
  }

  // Helper method to skip forward or backward.
  Future<void> _skipBy(Duration offset) async {
    final currentDuration = await _player?.getCurrentPosition();
    if (currentDuration != null) {
      final currentPosition = currentDuration;
      final newPosition = currentPosition + offset;
      await _player
          ?.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _initializePlayer() async {
    if (_player != null) return;

    _player = AudioPlayer();

    // Combine updates from both the player and audio service
    _setupCombinedPlayerListener();
    // _playerSubscription = rx.CombineLatestStream.combine4<Duration, Duration,
    //     PlayerState, PlaybackState, void>(
    //   _player!.onPositionChanged, // Player position changes
    //   _player!.onDurationChanged, // Player duration changes
    //   _player!
    //       .onPlayerStateChanged, // Player state changes (playing, paused, etc.)
    //   ref
    //       .watch(audioHandlerProvider)
    //       .playbackState, // audio_service playback state
    //   (position, duration, playerState, playbackState) {
    //     // Combine updates from both sources
    //     final isPlaying =
    //         playerState == PlayerState.playing || playbackState.playing;

    //     // Update the state with position, duration, and isPlaying
    //     state = state.copyWith(
    //       position: position,
    //       duration: duration,
    //       isPlaying: isPlaying,
    //     );
    //   },
    // ).listen((_) {});
  }

  void _setupCombinedPlayerListener() {
    final audioHandler = ref.watch(audioHandlerProvider);
    final player =
        _player; // Assuming this is your AudioPlayer instance from audioplayers

    // If player or audioHandler is null, we don't need to proceed.
    if (player == null) return;

    // Combine streams: position, buffered position, duration, and player state.
    final bufferedPositionStream = Stream<Duration>.value(
      Duration.zero,
    ); // Placeholder for buffered position if needed

    final combinedStream = rx.CombineLatestStream.combine4<Duration, Duration,
        Duration?, PlayerState, CombinedPlayerState>(
      player.onPositionChanged, // Player position changes
      bufferedPositionStream, // Buffered position (this is just a placeholder in this example)
      player.onDurationChanged, // Player duration changes
      player
          .onPlayerStateChanged, // Player state changes (playing, paused, etc.)
      (position, bufferedPosition, duration, playerState) =>
          CombinedPlayerState(
        position: position,
        bufferedPosition: bufferedPosition,
        duration: duration ?? Duration.zero,
        isPlaying: playerState ==
            PlayerState.playing, // Determine if the player is playing
      ),
    );

    // Subscribe to combined stream
    _combinedSubscription = combinedStream.listen((combinedState) {
      // Update the local Riverpod state (e.g., UI state)
      state = state.copyWith(
        position: combinedState.position,
        duration: combinedState.duration,
        isPlaying: combinedState.isPlaying,
      );

      // Update AudioService's playback state
      audioHandler.playbackState.add(
        audioHandler.playbackState.value.copyWith(
          controls: combinedState.isPlaying
              ? [MediaControl.pause, MediaControl.stop]
              : [MediaControl.play, MediaControl.stop],
          playing: combinedState.isPlaying,
          processingState: AudioProcessingState.ready,
          updatePosition: combinedState.position,
        ),
      );
    });
  }

  Future<Uri> _getAssetArtUri(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/logo_onstage.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return Uri.file(file.path);
  }
}
