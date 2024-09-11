import 'dart:async';

import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/duplicate_event_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

//This has to be kept alive because we need to keep the state of the event
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

  Future<void> initEventById(String eventId) async {
    state = state.copyWith(isLoading: true);
    await getEventById(eventId);
    await getRehearsals(eventId);
    await getStagers(eventId);
    state = state.copyWith(isLoading: false);
  }

  Future<void> publishEvent() async {
    const partialEvent = EventModel(
      eventStatus: EventStatus.published,
    );
    await _updateEvent(partialEvent);
  }

  Future<void> getEventById(String eventId) async {
    final event = await _eventsRepository.getEventById(eventId);

    state = state.copyWith(event: event);
  }

  Future<void> getRehearsals(String eventId) async {
    final rehearsals = await _eventsRepository.getRehearsalsByEventId(eventId);
    state = state.copyWith(rehearsals: rehearsals);
  }

  Future<void> addRehearsal(RehearsalModel rehearsal) async {
    state = state.copyWith(isLoading: true);
    final rehearsals = await _eventsRepository.addRehearsal(rehearsal);
    final updatedRehearsals = [...state.rehearsals, rehearsals];
    state = state.copyWith(rehearsals: updatedRehearsals, isLoading: false);
  }

  Future<void> updateRehearsal(RehearsalModel rehearsalRequest) async {
    state = state.copyWith(isLoading: true);
    final updatedRehearsal = await _eventsRepository.updateRehearsal(
      rehearsalRequest.id!,
      rehearsalRequest,
    );
    final updatedRehearsals = state.rehearsals
        .map(
          (rehearsal) => rehearsal.id == updatedRehearsal.id
              ? updatedRehearsal
              : rehearsal,
        )
        .toList();
    state = state.copyWith(rehearsals: updatedRehearsals, isLoading: false);
  }

  Future<void> deleteRehearsal(String rehearsalId) async {
    state = state.copyWith(isLoading: true);
    await _eventsRepository.deleteRehearsal(rehearsalId);
    final updatedRehearsals = state.rehearsals
        .where((rehearsal) => rehearsal.id != rehearsalId)
        .toList();
    state = state.copyWith(rehearsals: updatedRehearsals, isLoading: false);
  }

  Future<void> getStagers(String eventId) async {
    final stagers = await _eventsRepository.getStagersByEventId(eventId);
    state = state.copyWith(stagers: stagers);
  }

  Future<void> createEvent() async {
    state = state.copyWith(isLoading: true);
    final eventToCreate = _createDraftEvent();
    final event = await _eventsRepository.createEvent(eventToCreate);
    state = state.copyWith(isLoading: false, event: event);
  }

  Future<void> _updateEvent(EventModel updatedEvent) async {
    state = state.copyWith(isLoading: true);
    await _eventsRepository.updateEvent(state.event!.id!, updatedEvent);
    state = state.copyWith(isLoading: false);
  }

  Future<void> addStagerToEvent(CreateStagerRequest createStagerRequest) async {
    state = state.copyWith(isLoading: true);
    final stagers =
        await _eventsRepository.addStagerToEvent(createStagerRequest);
    state = state.copyWith(
      stagers: [...state.stagers, ...stagers],
      isLoading: false,
    );
  }

  Future<void> removeStagerFromEvent(String stagerId) async {
    state = state.copyWith(isLoading: true);
    try {
      await _eventsRepository.removeStagerFromEvent(stagerId);

      final stagers = await _eventsRepository.getStagersByEventId(
        state.event!.id!,
      );
      state = state.copyWith(stagers: stagers);
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateEventLocation(String location) {
    final partialEvent = EventModel(
      location: location,
    );
    unawaited(_updateEvent(partialEvent));
  }

  Future<void> updateEventName(String name) async {
    final partialEvent = EventModel(
      name: name,
    );
    unawaited(_updateEvent(partialEvent));
  }

  Future<void> duplicateEvent(DateTime newDateTime, String eventName) async {
    state = state.copyWith(isLoading: true);
    final duplicateEventRequest = DuplicateEventRequest(
      name: eventName,
      dateTime: newDateTime.toIso8601String(),
    );

    final newEvent = await _eventsRepository.duplicateEvent(
      state.event!.id!,
      duplicateEventRequest,
    );
    state = state.copyWith(event: newEvent, isLoading: false);
  }

  Future<void> deleteEvent() async {
    state = state.copyWith(isLoading: true);
    await _eventsRepository.deleteEvent(state.event!.id!);
    state = state.copyWith(isLoading: false);
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
