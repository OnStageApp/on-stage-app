import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/participant_profile.dart';

class EventState extends Equatable {
  const EventState({
    this.events = const [],
    this.pastEvents = const [],
    this.upcomingEvents = const [],
    this.thisWeekEvents = const [],
    this.filteredEvents = const [],
    this.playlist = const [],
    this.participants = const [],
    this.event ,
  });

  final List<EventOverview> events;
  final List<EventOverview> pastEvents;
  final List<EventOverview> upcomingEvents;
  final List<EventOverview> thisWeekEvents;
  final List<EventOverview> filteredEvents;
  final List<SongModel> playlist;
  final List<ParticipantProfile> participants;
  final EventModel? event;

  @override
  List<Object?> get props => events;

  EventState copyWith({
    List<EventOverview>? events,
    List<EventOverview>? pastEvents,
    List<EventOverview>? upcomingEvents,
    List<EventOverview>? thisWeekEvents,
    List<EventOverview>? filteredEvents,
    List<SongModel>? playlist,
    List<ParticipantProfile>? participants,
    EventModel? event,
  }) {
    return EventState(
      events: events ?? this.events,
      pastEvents: pastEvents ?? this.pastEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      thisWeekEvents: thisWeekEvents ?? this.thisWeekEvents,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      playlist: playlist ?? this.playlist,
      participants: participants ?? this.participants,
      event: event ?? this.event,
    );
  }
}
