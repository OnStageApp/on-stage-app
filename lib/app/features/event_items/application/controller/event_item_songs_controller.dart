import 'package:on_stage_app/app/features/event_items/application/controller/event_item_songs_controller_state.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_songs_controller.g.dart';

@riverpod
class EventItemSongsController extends _$EventItemSongsController {
  @override
  EventItemSongsControllerState build() {
    return const EventItemSongsControllerState();
  }

  void addSong(SongOverview addedSong) {
    state = state.copyWith(songs: [...state.songs, addedSong]);
  }

  void removeSong(SongOverview removedSong) {
    state = state.copyWith(
      songs: state.songs.where((song) => song.id != removedSong.id).toList(),
    );
  }
}
