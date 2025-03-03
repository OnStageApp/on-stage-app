import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/application/background_audio_handler.dart';
import 'package:on_stage_app/app/features/audio_player/domain/combined_player_state.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_notifier.g.dart';

@riverpod
class AudioController extends _$AudioController {
  AudioPlayerHandler? _audioHandler;
  StreamSubscription<CombinedPlayerState>? _playerStateSubscription;
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<MediaItem?>? _mediaItemSubscription;

  @override
  AudioPlayerState build() {
    // Clean up resources when the provider is disposed.
    ref.onDispose(() {
      _playerStateSubscription?.cancel();
      _playbackStateSubscription?.cancel();
      _mediaItemSubscription?.cancel();
      _audioHandler?.stop();
    });

    _initAudioService();
    return const AudioPlayerState();
  }

  Future<void> _initAudioService() async {
    if (_audioHandler != null) return;

    _audioHandler = await AudioService.init(
      builder: AudioPlayerHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.onstage.app.channel.audio',
        androidNotificationChannelName: 'Audio Playback',
        androidNotificationOngoing: true,
      ),
    );

    // Set up listeners for audio service state changes
    _setupAudioServiceListeners();
  }

  void _setupAudioServiceListeners() {
    if (_audioHandler == null) return;

    // Listen to playback state changes from audio_service
    _playbackStateSubscription =
        _audioHandler!.playbackState.listen((playbackState) {
      state = state.copyWith(
        isPlaying: playbackState.playing,
        position: playbackState.position,
      );
    });

    // Listen to media item changes
    _mediaItemSubscription = _audioHandler!.mediaItem.listen((mediaItem) {
      if (mediaItem != null && mediaItem.duration != null) {
        state = state.copyWith(duration: mediaItem.duration!);
      }
    });
  }

  // Improve error handling with user-friendly messages
  Future<void> openFile(
    SongFile file,
    String localUrl,
  ) async {
    await _initAudioService();
    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null, // Clear any previous errors
      );

      // Create MediaItem for audio_service
      final mediaItem = MediaItem(
        id: file.id,
        title: file.name,
        album: 'OnStage',
        artUri: artUri,
      );

      // Open file with audio handler
      await _audioHandler!.openFile(localUrl, mediaItem);

      // Update state
      state = state.copyWith(status: AudioStatus.ready);

      // Start playback
      await _audioHandler!.play();
    } catch (e, stackTrace) {
      logger.e(
        'Error opening file ${file.name}, path: $localUrl',
        e,
        stackTrace,
      );

      // Provide a user-friendly error message
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
    await _audioHandler?.stop();

    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    state = const AudioPlayerState();
  }

  void stopPlaying() {
    _audioHandler?.pause();
    state = state.copyWith(currentSongFile: null);
  }

  Future<void> resume() async {
    if (state.status == AudioStatus.ready) {
      await _audioHandler?.play();
    }
  }

  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioHandler?.seek(position);
  }

  Future<void> skipForward() async {
    if (_audioHandler != null) {
      final newPosition = state.position + const Duration(seconds: 10);
      final skipTo =
          newPosition < state.duration ? newPosition : state.duration;
      await _audioHandler!.seek(skipTo);
    }
  }

  Future<void> skipBackward() async {
    if (_audioHandler != null) {
      final newPosition = state.position - const Duration(seconds: 10);
      final skipTo = newPosition > Duration.zero ? newPosition : Duration.zero;
      await _audioHandler!.seek(skipTo);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
