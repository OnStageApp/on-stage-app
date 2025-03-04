import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  AudioPlayerHandler() {
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play, MediaControl.pause],
      ),
    );
  }

  final AudioPlayer player = AudioPlayer();

  Future<void> openFile(String localUrl, MediaItem newMediaItem) async {
    mediaItem.add(newMediaItem);
    await player.setSource(DeviceFileSource(localUrl));
  }

  @override
  Future<void> play() async {
    await player.resume();
    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        controls: [MediaControl.pause, MediaControl.stop],
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> pause() async {
    await player.pause();
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        controls: [MediaControl.play, MediaControl.stop],
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  @override
  Future<void> stop() async {
    await player.stop();
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
    return super.stop();
  }
}

final audioServiceProvider = FutureProvider<AudioPlayerHandler>((ref) async {
  final audioHandler = AudioPlayerHandler();

  ref.onDispose(() async {
    await audioHandler.player.dispose();
  });

  await AudioService.init(
    builder: () => audioHandler,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.onstage.app.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  return audioHandler;
});
