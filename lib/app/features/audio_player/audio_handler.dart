import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _mediaItemSubject = BehaviorSubject<MediaItem?>();

  @override
  BehaviorSubject<MediaItem?> get mediaItem => _mediaItemSubject;

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    _mediaItemSubject.add(mediaItem);
  }
}
