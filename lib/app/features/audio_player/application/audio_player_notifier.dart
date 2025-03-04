import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/application/background_audio_handler.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_player_notifier.g.dart';

/// A helper class that aggregates several player stream events.
class CombinedPlayerState {
  CombinedPlayerState({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
    required this.isPlaying,
  });
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  final bool isPlaying;
}

@riverpod
class AudioController extends _$AudioController {
  AudioPlayerHandler? _audioHandler;
  // Combined stream subscription to listen for position, duration, and playback changes.
  StreamSubscription<CombinedPlayerState>? _combinedSubscription;
  // Cache for the logo asset URI to avoid repeated disk writes.
  Uri? _cachedArtUri;

  @override
  AudioPlayerState build() {
    // Clean up resources when the provider is disposed.
    ref.onDispose(() {
      _cancelAllSubscriptions();
      _audioHandler?.stop();
    });

    // Initialize the audio service.
    _initAudioService();
    return const AudioPlayerState();
  }

  /// Asynchronously initializes the audio service using the FutureProvider.
  Future<void> _initAudioService() async {
    if (_audioHandler != null) return;
    try {
      // Await asynchronous initialization from the provider.
      _audioHandler = await ref.watch(audioServiceProvider.future);
      _setupCombinedPlayerListener();
    } catch (e, stackTrace) {
      logger.e('Error initializing AudioService', e, stackTrace);
      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: 'Failed to initialize audio service',
      );
    }
  }

  /// Sets up a combined stream listener for the audio player.
  void _setupCombinedPlayerListener() {
    if (_audioHandler == null) return;
    final player = _audioHandler!.player;

    // If buffering events become available, replace the fallback below.
    final bufferedPositionStream = Stream<Duration>.value(Duration.zero);

    // Combine streams: position, buffered position, duration, and player state.
    final combinedStream = CombineLatestStream.combine4<Duration, Duration,
        Duration?, PlayerState, CombinedPlayerState>(
      player.onPositionChanged,
      bufferedPositionStream,
      player.onDurationChanged,
      player.onPlayerStateChanged,
      (position, bufferedPosition, duration, playerState) =>
          CombinedPlayerState(
        position: position,
        bufferedPosition: bufferedPosition,
        duration: duration ?? Duration.zero,
        isPlaying: playerState == PlayerState.playing,
      ),
    );

    _combinedSubscription = combinedStream.listen((combinedState) {
      // Update the local Riverpod state.
      state = state.copyWith(
        position: combinedState.position,
        duration: combinedState.duration,
        isPlaying: combinedState.isPlaying,
      );
      // Update AudioService's playback state.
      _audioHandler!.playbackState.add(
        _audioHandler!.playbackState.value.copyWith(
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

  /// Cancels all active subscriptions.
  void _cancelAllSubscriptions() {
    _combinedSubscription?.cancel();
    _combinedSubscription = null;
  }

  /// Opens the given [file] for playback using its [localUrl].
  Future<void> openFile(SongFile file, String localUrl) async {
    await _initAudioService();
    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    // Ensure the combined listener is active.
    if (_combinedSubscription == null) {
      _setupCombinedPlayerListener();
    }

    try {
      // Update state to loading and clear any previous errors.
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null,
      );

      // Create a MediaItem for AudioService notifications.
      final mediaItem = MediaItem(
        id: file.id,
        title: file.name,
        album: 'OnStage',
        artUri: artUri,
      );

      // Open the file in the AudioHandler.
      await _audioHandler!.openFile(localUrl, mediaItem);

      // Update state to ready.
      state = state.copyWith(status: AudioStatus.ready);

      // Start playback.
      await _audioHandler!.play();
    } on PlatformException catch (pe, stackTrace) {
      logger.e('Platform exception opening file ${file.name}', pe, stackTrace);
      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: 'System error: ${pe.message}',
      );
    } on FormatException catch (fe, stackTrace) {
      logger.e('Format exception opening file ${file.name}', fe, stackTrace);
      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: 'Invalid audio format',
      );
    } on SocketException catch (se, stackTrace) {
      logger.e('Network error opening file ${file.name}', se, stackTrace);
      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: 'Network error: Please check your connection',
      );
    } catch (e, stackTrace) {
      logger.e('Error opening file ${file.name}', e, stackTrace);
      state = state.copyWith(
        status: AudioStatus.error,
        errorMessage: 'Playback error: Please try again',
      );
    }
  }

  /// Stops playback and resets the state.
  Future<void> closeFile() async {
    await _audioHandler?.stop();
    state = const AudioPlayerState();
  }

  /// Pauses playback and clears the current song.
  void stopPlaying() {
    _audioHandler?.pause();
    state = state.copyWith(currentSongFile: null);
  }

  /// Resumes playback if audio is ready.
  Future<void> resume() async {
    if (state.status == AudioStatus.ready) {
      await _audioHandler?.play();
    }
  }

  /// Pauses playback.
  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  /// Seeks to the specified [position].
  Future<void> seek(Duration position) async {
    await _audioHandler?.seek(position);
  }

  /// Skips forward by 10 seconds or until end of duration.
  Future<void> skipForward() async {
    if (_audioHandler != null) {
      final newPosition = state.position + const Duration(seconds: 10);
      final skipTo =
          newPosition < state.duration ? newPosition : state.duration;
      await _audioHandler!.seek(skipTo);
    }
  }

  /// Skips backward by 10 seconds or until beginning.
  Future<void> skipBackward() async {
    if (_audioHandler != null) {
      final newPosition = state.position - const Duration(seconds: 10);
      final skipTo = newPosition > Duration.zero ? newPosition : Duration.zero;
      await _audioHandler!.seek(skipTo);
    }
  }

  /// Formats a [duration] into MM:SS.
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Loads an asset and returns its URI. Caches it to avoid repeated disk writes.
  Future<Uri> _getAssetArtUri(String assetPath) async {
    if (_cachedArtUri != null) return _cachedArtUri!;
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/logo_onstage.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    _cachedArtUri = Uri.file(file.path);
    return _cachedArtUri!;
  }
}
