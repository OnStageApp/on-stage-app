import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/application/event_item_notifier/event_item_state.dart';
import 'package:on_stage_app/app/features/event_items/data/event_items_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_notifier.g.dart';

@Riverpod()
class EventItemNotifier extends _$EventItemNotifier {
  EventItemsRepository? _eventItemsRepository;

  EventItemsRepository get eventItemsRepository {
    _eventItemsRepository ??= EventItemsRepository(ref.read(dioProvider));
    return _eventItemsRepository!;
  }

  @override
  EventItemState build() {
    final dio = ref.read(dioProvider);
    _eventItemsRepository = EventItemsRepository(dio);
    return const EventItemState();
  }

  Future<void> getLeadVocals(String eventItemId) async {
    var leadVocalStagers =
        await eventItemsRepository.getLeadVocals(eventItemId);
    leadVocalStagers = await Future.wait(
      leadVocalStagers.map(_getStagerWithPhoto),
    );
    state = state.copyWith(
      leadVocalStagers: leadVocalStagers,
      selectedLeadVocalStagers: leadVocalStagers,
    );
  }

  Future<void> updateLeadVocals(
    String eventItemId,
    List<Stager> leadVocalStagers,
  ) async {
    state = state.copyWith(
      leadVocalStagers: leadVocalStagers,
      selectedLeadVocalStagers: leadVocalStagers,
    );
    final stagerIds = leadVocalStagers.map((e) => e.id).toList();
    unawaited(eventItemsRepository.updateLeadVocals(eventItemId, stagerIds));
  }

  Future<void> removeLeadVocal(
    String eventItemId,
    String stagerId,
  ) async {
    final updatedLeadVocals = List<Stager>.from(state.leadVocalStagers)
      ..removeWhere((s) => s.id == stagerId);
    state = state.copyWith(
      leadVocalStagers: updatedLeadVocals,
      selectedLeadVocalStagers: updatedLeadVocals,
    );
    unawaited(eventItemsRepository.deleteLeadVocals(eventItemId, stagerId));
  }

  void selectLeadVocals(Stager stager) {
    final updatedCache = List<Stager>.from(state.selectedLeadVocalStagers)
      ..add(stager);
    state = state.copyWith(selectedLeadVocalStagers: updatedCache);
  }

  void unselectLeadVocals(Stager stager) {
    final updatedCache = List<Stager>.from(state.selectedLeadVocalStagers)
      ..removeWhere((s) => s.id == stager.id);
    state = state.copyWith(selectedLeadVocalStagers: updatedCache);
  }

  List<Stager> getSelectedLeadVocals() {
    return state.selectedLeadVocalStagers;
  }

  Future<Stager> _getStagerWithPhoto(
    Stager stager,
  ) async {
    final photo = await _setPhotosFromLocalStorage(stager.userId);
    if (photo == null) return stager;
    return stager.copyWith(profilePicture: photo);
  }

  Future<Uint8List?> _setPhotosFromLocalStorage(
    String? userId,
  ) async {
    if (userId == null) return null;
    final teamMemberPhoto =
        await ref.read(databaseProvider).getTeamMemberPhoto(userId);
    if (teamMemberPhoto == null || teamMemberPhoto.profilePicture == null) {
      return null;
    }
    return teamMemberPhoto.profilePicture;
  }
}
