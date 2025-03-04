import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/audio_handler.dart';
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
  final MyAudioHandler _audioHandler = MyAudioHandler();

  @override
  AudioPlayerState build() {
    ref.onDispose(() {
      ref.onDispose(() {
        _playerSubscription?.cancel();
        _player?.dispose();
        _audioHandler.stop();
      });
    });
    return const AudioPlayerState();
  }

  Future<void> openFile(
    SongFile file,
    String localUrl,
  ) async {
    await _initializePlayer();

    // Get the album art as a URI (for background display)
    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null, // Clear any previous errors
      );

      // In audioplayers, you set the URL and then start playback.
      // setUrl returns an int result (1 means success)
      await _player!.setSourceDeviceFile(localUrl);
      // if (result != 1) {
      //   throw Exception('Error setting URL for audio');
      // }

      // Once the URL is set, update state and start playback.
      state = state.copyWith(status: AudioStatus.ready);
      await _player!.resume();

      // Update AudioService's background media item.
      // This will help display the correct info in the system’s media controls.
      await _audioHandler.updateMediaItem(
        MediaItem(
          id: file.id,
          album: 'OnStage',
          title: file.name,
          artUri: artUri,
        ),
      );
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
      await _player?.resume();
    }
  }

  Future<void> pause() async {
    await _player?.pause();
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
    state = state.copyWith(player: _player);

    _playerSubscription =
        rx.CombineLatestStream.combine3<Duration, Duration, PlayerState, void>(
      _player!.onPositionChanged,
      _player!.onDurationChanged,
      _player!.onPlayerStateChanged,
      (position, duration, playerState) {
        state = state.copyWith(
          position: position,
          duration: duration,
          isPlaying: playerState == PlayerState.playing,
        );
      },
    ).listen((_) {});
  }

  Future<Uri> _getAssetArtUri(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/logo_onstage.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return Uri.file(file.path);
  }
}
