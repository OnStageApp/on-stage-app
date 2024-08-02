import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';

class EventItemsState extends Equatable {
  const EventItemsState({
    this.eventItems = const [],
  });

  final List<EventItem> eventItems;

  @override
  List<Object?> get props => [eventItems];

  EventItemsState copyWith({
    List<EventItem>? eventItems,
  }) {
    return EventItemsState(
      eventItems: eventItems ?? this.eventItems,
    );
  }
}
