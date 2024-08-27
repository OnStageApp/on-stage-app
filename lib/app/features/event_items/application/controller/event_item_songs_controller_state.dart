import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'event_item_songs_controller_state.freezed.dart';

@Freezed()
class EventItemSongsControllerState with _$EventItemSongsControllerState {
  const factory EventItemSongsControllerState({
    @Default([]) List<SongOverview> songs,
  }) = _EventItemSongsControllerState;
}
