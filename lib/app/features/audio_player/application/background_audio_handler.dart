// audio_player_handler.dart

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A custom audio handler that uses audioplayers to perform playback.
/// This handler runs in the background when audio_service is initialized.
class AudioPlayerHandler extends BaseAudioHandler {
  AudioPlayerHandler() {
    // Listen to player state changes and update the playback state.
    _player.onPlayerStateChanged.listen((playerState) {
      final isPlaying = playerState == PlayerState.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: isPlaying
              ? [MediaControl.pause, MediaControl.stop]
              : [MediaControl.play, MediaControl.stop],
          playing: isPlaying,
          processingState: AudioProcessingState.ready,
          updatePosition: _currentPosition,
        ),
      );
    });

    // Listen to position changes.
    _player.onPositionChanged.listen((position) {
      _currentPosition = position;
      playbackState.add(
        playbackState.value.copyWith(updatePosition: position),
      );
    });

    // Listen to duration changes.
    _player.onDurationChanged.listen((duration) {
      final currentItem = mediaItem.value;
      if (currentItem != null) {
        // Update the current media item with the new duration.
        mediaItem.add(currentItem.copyWith(duration: duration));
      }
    });
  }
  final AudioPlayer _player = AudioPlayer();
  Duration _currentPosition = Duration.zero;

  /// Opens a file for playback. It sets the media item for notifications and
  /// configures the audio player with the local file.
  Future<void> openFile(String localUrl, MediaItem newMediaItem) async {
    // Update the media item stream so that notifications show the correct info.
    mediaItem.add(newMediaItem);
    // Set the audio source to a local file.
    await _player.setSource(DeviceFileSource(localUrl));
  }

  @override
  Future<void> play() async {
    await _player.resume();
    playbackState.add(
      playbackState.value.copyWith(playing: true),
    );
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    playbackState.add(
      playbackState.value.copyWith(playing: false),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(
      playbackState.value.copyWith(playing: false),
    );
    return super.stop();
  }
}

final audioServiceProvider = Provider<AudioPlayerHandler>((ref) {
  final audioHandler = AudioPlayerHandler();

  AudioService.init(
    builder: () => audioHandler,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.onstage.app.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  return audioHandler;
});
