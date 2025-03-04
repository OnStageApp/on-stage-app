import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler();

  final _mediaItemSubject = BehaviorSubject<MediaItem?>();
  final _queueSubject = BehaviorSubject<List<MediaItem>>.seeded([]);
  final _playbackStateSubject = BehaviorSubject<PlaybackState>.seeded(
    PlaybackState(
      controls: [
        MediaControl.rewind,
        MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    ),
  );

  @override
  BehaviorSubject<MediaItem?> get mediaItem => _mediaItemSubject;

  @override
  BehaviorSubject<List<MediaItem>> get queue => _queueSubject;

  @override
  BehaviorSubject<PlaybackState> get playbackState => _playbackStateSubject;

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    _mediaItemSubject.add(mediaItem);
    if (_queueSubject.value.isEmpty) {
      _queueSubject.add([mediaItem]);
    }
  }

  @override
  Future<void> play() async {
    _playbackStateSubject.add(
      _playbackStateSubject.value.copyWith(
        playing: true,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> pause() async {
    _playbackStateSubject.add(
      _playbackStateSubject.value.copyWith(
        playing: false,
      ),
    );
  }

  @override
  Future<void> stop() async {
    _playbackStateSubject.add(
      _playbackStateSubject.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
        updatePosition: Duration.zero,
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    _playbackStateSubject.add(
      _playbackStateSubject.value.copyWith(
        updatePosition: position,
      ),
    );
  }

  @override
  Future<void> skipToNext() async {
    final queue = _queueSubject.value;
    final mediaItem = _mediaItemSubject.valueOrNull;

    if (queue.isEmpty || mediaItem == null) return;

    final index = queue.indexWhere((item) => item.id == mediaItem.id);
    if (index == -1 || index == queue.length - 1) return;

    _mediaItemSubject.add(queue[index + 1]);
  }

  @override
  Future<void> skipToPrevious() async {
    final queue = _queueSubject.value;
    final mediaItem = _mediaItemSubject.valueOrNull;

    if (queue.isEmpty || mediaItem == null) return;

    final index = queue.indexWhere((item) => item.id == mediaItem.id);
    if (index <= 0) return;

    _mediaItemSubject.add(queue[index - 1]);
  }

  @override
  Future<void> fastForward() => skipForward();

  @override
  Future<void> rewind() => skipBackward();

  Future<void> skipForward([
    Duration duration = const Duration(seconds: 10),
  ]) async {
    final currentState = _playbackStateSubject.value;
    final position = currentState.position + duration;

    await seek(position);
  }

  Future<void> skipBackward([
    Duration duration = const Duration(seconds: 10),
  ]) async {
    final currentState = _playbackStateSubject.value;
    final position = currentState.position - duration;

    await seek(position.isNegative ? Duration.zero : position);
  }

  Future<void> dispose() async {
    await _mediaItemSubject.close();
    await _queueSubject.close();
    await _playbackStateSubject.close();
  }
}

final audioHandlerProvider = Provider<MyAudioHandler>((ref) {
  throw UnimplementedError('audioHandlerProvider not initialized');
});
