import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';


class EventState extends Equatable {
  const EventState({
    this.events = const [],
    this.pastEvents = const [],
    this.upcomingEvents = const[],
    this.thisWeekEvents = const [],
    this.filteredEvents = const[],
  });

  final List<EventModel> events;
  final List<EventModel> pastEvents;
  final List<EventModel> upcomingEvents;
  final List<EventModel> thisWeekEvents;
  final List<EventModel> filteredEvents;

  @override
  List<Object?> get props => events;

  EventState copyWith({
    List<EventModel>? events,
    List<EventModel>? pastEvents,
    List<EventModel>? upcomingEvents,
    List<EventModel>? thisWeekEvents,
    List<EventModel>? filteredEvents,
  }) {
    return EventState(
      events: events ?? this.events,
      pastEvents: pastEvents ?? this.pastEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      thisWeekEvents: thisWeekEvents ?? this.thisWeekEvents,
      filteredEvents: filteredEvents ?? this.filteredEvents,
    );
  }

}