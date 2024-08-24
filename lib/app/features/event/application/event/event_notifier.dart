import 'dart:async';

import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  late final EventsRepository _eventsRepository;

  @override
  EventState build() {
    final dio = ref.read(dioProvider);
    _eventsRepository = EventsRepository(dio);
    return const EventState();
  }

  Future<void> init() async {
    if (state.event != null) {
      return;
    }
    logger.i('init event provider state');
  }

  Future<void> getEventById(String eventId) async {
    state = state.copyWith(isLoading: true);
    final event = await _eventsRepository.getEventById(eventId);

    state = state.copyWith(event: event, isLoading: false);
  }

  Future<void> getPlaylist() async {
    if (state.playlist.isNotEmpty) {
      state = state.copyWith(playlist: state.playlist);
      return;
    }
    state = state.copyWith(isLoading: true);
    state = state.copyWith(playlist: [], isLoading: false);
  }

  Future<void> getRehearsals(String eventId) async {
    state = state.copyWith(isLoading: true);
    final rehearsals = await _eventsRepository.getRehearsalsByEventId(eventId);
    state = state.copyWith(rehearsals: rehearsals, isLoading: false);
  }

  Future<void> getStagers(String eventId) async {
    state = state.copyWith(isLoading: true);
    final stagers = await _eventsRepository.getStagersByEventId(eventId);
    state = state.copyWith(stagers: stagers, isLoading: false);
  }

  Future<void> addEvent() async {
    state = state.copyWith(isLoading: true);
    final eventToCreate = _createDraftEvent();
    final event = await _eventsRepository.createEvent(eventToCreate);
    state = state.copyWith(isLoading: false, event: event);
  }

  Future<void> updateEvent(EventModel updatedEvent) async {
    state = state.copyWith(isLoading: true);
    await _eventsRepository.updateEvent(state.event!.id!, updatedEvent);
    state = state.copyWith(isLoading: false);
  }

  Future<void> addStagerToEvent(CreateStagerRequest createStagerRequest) async {
    state = state.copyWith(isLoading: true);
    final stager = _eventsRepository.addStagerToEvent(createStagerRequest);
    state = state.copyWith(isLoading: false);
  }

  void updateEventLocation(String location) {
    final partialEvent = EventModel(
      location: location,
    );
    unawaited(updateEvent(partialEvent));
  }

  Future<void> updateEventName(String name) async {
    final partialEvent = EventModel(
      name: name,
    );
    unawaited(updateEvent(partialEvent));
  }

  CreateEventModel _createDraftEvent() {
    final eventControllerState = ref.read(eventControllerProvider);
    return CreateEventModel(
      name: eventControllerState.eventName,
      dateTime: eventControllerState.dateTime,
      location: eventControllerState.eventLocation,
      eventStatus: EventStatus.draft,
      userIds: eventControllerState.addedUsers.map((p) => p.id).toList(),
      rehearsals: eventControllerState.rehearsals,
    );
  }

  int getAcceptedInvitees() {
    return state.stagers
        .where(
          (stager) => stager.participationStatus == StagerStatusEnum.CONFIRMED,
        )
        .length;
  }
}
