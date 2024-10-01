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
    var leadVocals = await eventItemsRepository.getLeadVocals(eventItemId);
    leadVocals = await Future.wait(
      leadVocals.map(_getStagerWithPhoto),
    );
    state = state.copyWith(
      leadVocals: leadVocals,
      leadVocalsCacheList: leadVocals,
    );
  }

  Future<void> updateLeadVocals(
    String eventItemId,
    List<Stager> leadVocals,
  ) async {
    state = state.copyWith(
      leadVocals: leadVocals,
      leadVocalsCacheList: leadVocals,
    );
    final leadVocalIds = leadVocals.map((e) => e.id).toList();
    unawaited(eventItemsRepository.updateLeadVocals(eventItemId, leadVocalIds));
  }

  void addToLeadVocalsCache(Stager stager) {
    final updatedCache = List<Stager>.from(state.leadVocalsCacheList)
      ..add(stager);
    state = state.copyWith(leadVocalsCacheList: updatedCache);
  }

  void removeFromLeadVocalsCache(Stager stager) {
    final updatedCache = List<Stager>.from(state.leadVocalsCacheList)
      ..removeWhere((s) => s.id == stager.id);
    state = state.copyWith(leadVocalsCacheList: updatedCache);
  }

  List<Stager> getLeadVocalsCache() {
    return state.leadVocalsCacheList;
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
