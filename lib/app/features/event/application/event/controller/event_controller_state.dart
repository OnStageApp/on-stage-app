import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager_overview.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

class EventControllerState extends Equatable {
  const EventControllerState({
    this.addedParticipants = const [],
    this.invitePeopleButtonText = 'Invite People',
    this.rehearsals = const [],
    this.songs = const [],
    this.moments = const [],
    this.eventItems = const [],
  });

  final List<StagerOverview> addedParticipants;
  final String invitePeopleButtonText;
  final List<Rehearsal> rehearsals;
  final List<SongOverview> songs;
  final List<String> moments;
  final List<EventItem> eventItems;

  @override
  List<Object?> get props => [
        addedParticipants,
        rehearsals,
        songs,
        moments,
        eventItems,
      ];

  EventControllerState copyWith({
    List<StagerOverview>? addedParticipants,
    String? invitePeopleButtonText,
    List<Rehearsal>? rehearsals,
    List<SongOverview>? songs,
    List<String>? moments,
    List<EventItem>? eventItems,
  }) {
    return EventControllerState(
      addedParticipants: addedParticipants ?? this.addedParticipants,
      invitePeopleButtonText:
          invitePeopleButtonText ?? this.invitePeopleButtonText,
      rehearsals: rehearsals ?? this.rehearsals,
      songs: songs ?? this.songs,
      moments: moments ?? this.moments,
      eventItems: eventItems ?? this.eventItems,
    );
  }
}
