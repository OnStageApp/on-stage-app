import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_response.dart';
import 'package:on_stage_app/app/features/event/domain/models/upcoming_event/upcoming_event_model.dart';

class EventsState extends Equatable {
  const EventsState({
    this.eventsResponse = const EventsResponse(
      events: [],
      hasMore: false,
    ),
    this.filteredEventsResponse = const EventsResponse(
      events: [],
      hasMore: false,
    ),
    this.pastEventsResponse = const EventsResponse(
      events: [],
      hasMore: false,
    ),
    this.upcomingEventsResponse = const EventsResponse(
      events: [],
      hasMore: false,
    ),
    this.upcomingEvent,
    this.isLoading = false,
    this.page = 1,
  });

  final EventsResponse eventsResponse;
  final EventsResponse filteredEventsResponse;
  final EventsResponse pastEventsResponse;
  final EventsResponse upcomingEventsResponse;
  final UpcomingEventModel? upcomingEvent;
  final bool isLoading;
  final int page;

  @override
  List<Object?> get props => [eventsResponse];

  EventsState copyWith({
    EventsResponse? eventsResponse,
    EventsResponse? pastEventsResponse,
    EventsResponse? upcomingEventsResponse,
    EventsResponse? filteredEventsResponse,
    UpcomingEventModel? upcomingEvent,
    EventModel? event,
    bool? isLoading,
    int? page,
  }) {
    return EventsState(
      eventsResponse: eventsResponse ?? this.eventsResponse,
      filteredEventsResponse:
          filteredEventsResponse ?? this.filteredEventsResponse,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      pastEventsResponse: pastEventsResponse ?? this.pastEventsResponse,
      upcomingEventsResponse:
          upcomingEventsResponse ?? this.upcomingEventsResponse,
      upcomingEvent: upcomingEvent ?? this.upcomingEvent,
    );
  }
}
