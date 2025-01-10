import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_state.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/duplicate_event_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_all_stagers_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/edit_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

//This has to be kept alive because we need to keep the state of the event
@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  EventsRepository? _eventsRepository;

  EventsRepository get eventsRepository {
    _eventsRepository ??= EventsRepository(ref.watch(dioProvider));
    return _eventsRepository!;
  }

  @override
  EventState build() {
    return const EventState();
  }

  Future<void> init() async {
    if (state.event != null) {
      return;
    }
    logger.i('init event provider state');
  }

  void resetState() {
    state = const EventState();
  }

  Future<void> initEventById(String eventId) async {
    unawaited(getEventById(eventId));
    unawaited(getRehearsals(eventId));
  }

  Future<void> publishEvent() async {
    const partialEvent = EventModel(
      eventStatus: EventStatus.published,
    );
    await _updateEvent(partialEvent);
  }

  Future<void> getEventById(String eventId) async {
    final event = await eventsRepository.getEventById(eventId);
    state = state.copyWith(event: event);
  }

  Future<void> getRehearsals(String eventId) async {
    final rehearsals = await eventsRepository.getRehearsalsByEventId(eventId);
    state = state.copyWith(rehearsals: rehearsals);
  }

  Future<void> addRehearsal(RehearsalModel rehearsal) async {
    final previousRehearsals = state.rehearsals;
    try {
      final updatedRehearsals = [...state.rehearsals, rehearsal];
      state = state.copyWith(rehearsals: updatedRehearsals, isLoading: false);
      await eventsRepository.addRehearsal(rehearsal);
    } catch (e) {
      state = state.copyWith(rehearsals: previousRehearsals);
      logger.e('Error adding rehearsal: $e');
    }
  }

  Future<void> updateRehearsal(RehearsalModel rehearsalRequest) async {
    state = state.copyWith(isLoading: true);
    final updatedRehearsal = await eventsRepository.updateRehearsal(
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
    await eventsRepository.deleteRehearsal(rehearsalId);
    final updatedRehearsals = state.rehearsals
        .where((rehearsal) => rehearsal.id != rehearsalId)
        .toList();
    state = state.copyWith(rehearsals: updatedRehearsals, isLoading: false);
  }

  Future<void> createEmptyEvent() async {
    state = state.copyWith(isLoading: true);
    final event = await eventsRepository.createEvent(const CreateEventModel());
    state = state.copyWith(event: event);
  }

  Future<void> createEvent() async {
    state = state.copyWith(isLoading: true);
    final eventToCreate = _createDraftEvent();
    final event = await eventsRepository.createEvent(eventToCreate);
    state = state.copyWith(event: event);
  }

  Future<void> _updateEvent(EventModel updatedEvent) async {
    state = state.copyWith(isLoading: true);
    if (state.event!.id == null) {
      return;
    }
    await eventsRepository.updateEvent(state.event!.id!, updatedEvent);
    state = state.copyWith(isLoading: false);
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

    final newEvent = await eventsRepository.duplicateEvent(
      state.event!.id!,
      duplicateEventRequest,
    );
    state = state.copyWith(event: newEvent, isLoading: false);
  }

  Future<void> deleteEventAndGetAll() async {
    await deleteEvent();
    unawaited(ref.read(eventsNotifierProvider.notifier).initEvents());
  }

  Future<void> deleteEvent() async {
    state = state.copyWith(isLoading: true);
    if (state.event?.id == null) {
      throw Exception('Event id is null');
    }
    await eventsRepository.deleteEvent(state.event!.id!);
    state = state.copyWith(isLoading: false);
  }

  CreateEventModel _createDraftEvent() {
    final eventControllerState = ref.read(eventControllerProvider);
    return CreateEventModel(
      name: eventControllerState.eventName,
      dateTime: eventControllerState.dateTime,
      location: eventControllerState.eventLocation,
      rehearsals: eventControllerState.rehearsals,
    );
  }

  /// New Stagers Methods
  Future<void> addStagersToEvent(
    List<String> selectedMemberIds,
    String positionId,
    String groupId,
  ) async {
    try {
      final request = CreateAllStagersRequest(
        eventId: state.event?.id ?? '',
        stagers: selectedMemberIds
            .map(
              (teamMemberId) => CreateStagerRequest(
                positionId: positionId,
                groupId: groupId,
                teamMemberId: teamMemberId,
              ),
            )
            .toList(),
      );

      final newStagers = await eventsRepository.addStagerToEvent(request);
      final newStagersWithPhoto =
          await Future.wait(newStagers.map(_getStagerWithPhoto));

      final updatedStagers = [...state.stagers, ...newStagersWithPhoto];

      state = state.copyWith(
        stagers: updatedStagers,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getStagersByGroupAndEvent({
    required String eventId,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final stagers = await eventsRepository.getStagersByGroupAndEvent(
        eventId: eventId,
        groupId: groupId,
      );
      final stagersWithPhoto =
          await Future.wait(stagers.map(_getStagerWithPhoto));
      state = state.copyWith(stagers: stagersWithPhoto, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> setStatusForStager({
    required StagerStatusEnum participationStatus,
    required String stagerId,
  }) async {
    final newStager = EditStagerRequest(
      participationStatus: participationStatus,
    );
    await eventsRepository.updateStager(stagerId, newStager);
  }

  Future<void> updateStager(EditStagerRequest stagerRequest) async {
    final userId = ref.read(userNotifierProvider).currentUser!.id;
    state = state.copyWith(isLoading: true);
    final stager =
        state.stagers.firstWhere((stager) => stager.userId == userId);
    await eventsRepository.updateStager(stager.id, stagerRequest);
    state = state.copyWith(isLoading: false);
  }

  Future<Stager> _getStagerWithPhoto(
    Stager stager,
  ) async {
    final photo = await _setPhotosFromLocalStorage(stager.userId);
    return stager.copyWith(profilePicture: photo);
  }

  int getAcceptedInvitees() {
    return state.stagers
        .where(
          (stager) => stager.participationStatus == StagerStatusEnum.CONFIRMED,
        )
        .length;
  }

  Future<Uint8List?> _setPhotosFromLocalStorage(
    String? userId,
  ) async {
    if (userId == null) return null;
    final photo = await ref.read(databaseProvider).getTeamMemberPhoto(userId);
    return photo?.profilePicture;
  }

  Future<void> removeStagerFromEvent(String stagerId) async {
    try {
      await eventsRepository.removeStagerFromEvent(stagerId);
      final updatedStagers =
          state.stagers.where((stager) => stager.id != stagerId).toList();
      state = state.copyWith(stagers: updatedStagers);
    } catch (e) {
      rethrow;
    }
  }

// Future<String> getStagerByEventAndTeamMember(
//   String eventId,
//   String teamMemberId,
// ) async {
//   final stager = await eventsRepository.getStagerByEventAndTeamMember(
//     eventId,
//     teamMemberId,
//   );
//   return stager.id;
// }
}
