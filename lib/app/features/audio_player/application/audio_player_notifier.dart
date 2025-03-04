import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_handler/audio_handler.dart';
import 'package:on_stage_app/app/features/audio_player/domain/combined_player_state.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart' as rx;

part 'audio_player_notifier.g.dart';

@riverpod
class AudioController extends _$AudioController {
  AudioPlayerHandler? _audioHandler;
  StreamSubscription<CombinedPlayerState>? _combinedSubscription;
  Uri? _cachedArtUri;

  @override
  AudioPlayerState build() {
    ref.onDispose(() {
      _cancelAllSubscriptions();
      _audioHandler?.stop();
    });

    _initAudioService();
    return const AudioPlayerState();
  }

  Future<void> _initAudioService() async {
    if (_audioHandler != null) return;
    try {
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

  void _setupCombinedPlayerListener() {
    if (_audioHandler == null) return;
    final player = _audioHandler!.player;

    final bufferedPositionStream = Stream<Duration>.value(Duration.zero);

    final combinedStream = rx.CombineLatestStream.combine4<Duration, Duration,
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
      state = state.copyWith(
        position: combinedState.position,
        duration: combinedState.duration,
        isPlaying: combinedState.isPlaying,
      );
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

  void _cancelAllSubscriptions() {
    _combinedSubscription?.cancel();
    _combinedSubscription = null;
  }

  Future<void> openFile(SongFile file, String localUrl) async {
    await _initAudioService();
    final artUri = await _getAssetArtUri('assets/icons/logo_onstage.png');

    if (_combinedSubscription == null) {
      _setupCombinedPlayerListener();
    }

    try {
      state = state.copyWith(
        status: AudioStatus.loading,
        currentSongFile: file,
        errorMessage: null,
      );

      final mediaItem = MediaItem(
        id: file.id,
        title: file.name,
        album: 'OnStage',
        artUri: artUri,
      );

      await _audioHandler!.openFile(localUrl, mediaItem);

      state = state.copyWith(status: AudioStatus.ready);

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

  Future<void> closeFile() async {
    await _audioHandler?.stop();
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
    if (_cachedArtUri != null) return _cachedArtUri!;
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/logo_onstage.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    _cachedArtUri = Uri.file(file.path);
    return _cachedArtUri!;
  }
}
