import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';

part 'event_items_state.freezed.dart';

@Freezed()
class EventItemsState with _$EventItemsState {
  const factory EventItemsState({
    @Default(false) bool isLoading,
    @Default([]) List<EventItem> eventItems,
    @Default([]) List<SongModelV2> songsFromEvent,
    @Default(-1) int currentIndex,
  }) = _EventItemsState;
}
