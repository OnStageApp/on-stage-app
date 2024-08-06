import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class EventsState extends Equatable {
  const EventsState({
    this.events = const [],
    this.filteredEvents = const [],
    this.isLoading = false,
  });

  final List<EventOverview> events;
  final List<EventOverview> filteredEvents;
  final bool isLoading;

  @override
  List<Object?> get props => events;

  EventsState copyWith({
    List<EventOverview>? events,
    List<EventOverview>? pastEvents,
    List<EventOverview>? upcomingEvents,
    List<EventOverview>? thisWeekEvents,
    List<EventOverview>? filteredEvents,
    List<SongModel>? playlist,
    List<StagerOverview>? stagers,
    EventModel? event,
    bool? isLoading,
  }) {
    return EventsState(
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
