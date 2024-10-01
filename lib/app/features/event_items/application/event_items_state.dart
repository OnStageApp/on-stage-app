import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';

part 'event_items_state.freezed.dart';

@Freezed()
class EventItemsState with _$EventItemsState {
  const factory EventItemsState({
    @Default(false) bool isLoading,
    @Default([]) List<EventItem> eventItems,
    @Default([]) List<EventItem> songEventItems,
    @Default(0) int currentIndex,
  }) = _EventItemsState;
}
