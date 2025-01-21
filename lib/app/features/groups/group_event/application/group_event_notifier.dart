import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_state.dart';
import 'package:on_stage_app/app/features/groups/group_event/data/group_event_repository.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_event_notifier.g.dart';

@riverpod
class GroupEventNotifier extends _$GroupEventNotifier {
  GroupEventRepository get _groupEventRepo => ref.read(groupEventRepoProvider);

  @override
  GroupEventState build() {
    return const GroupEventState();
  }

  Future<void> getGroupsEvent(String eventId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final groups = await _groupEventRepo.getGroups(eventId);
      final updatedGroups = await Future.wait(
        groups.map(_updateGroupWithPhotos),
      );

      state = state.copyWith(groupEvents: updatedGroups);
    } catch (e) {
      logger.e('Error getting groups for event $eventId', e);
      state = state.copyWith(error: e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getGroupEventById(String eventId, String groupId) async {
    state = state.copyWith(error: null);
    try {
      final group = await _groupEventRepo.getGroupById(eventId, groupId);
      final updatedGroup = await _updateGroupWithPhotos(group);

      state = state.copyWith(
        groupEvents: state.groupEvents
            .map((e) => e.id == groupId ? updatedGroup : e)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    }
  }

  Future<GroupEvent> _updateGroupWithPhotos(GroupEvent group) async {
    if (group.stagersWithPhoto?.isEmpty ?? true) return group;

    final photos = await Future.wait(
      group.stagersWithPhoto!.map((userId) async {
        final teamMember =
            await ref.read(databaseProvider).getTeamMemberPhoto(userId);
        return teamMember?.profilePicture;
      }),
    );

    return group.copyWith(
      profilePictures: photos.whereType<Uint8List>().toList(),
    );
  }

  (int, List<Uint8List>) getGroupsStatsAndPhotos() {
    final groups = state.groupEvents;
    final totalMembers =
        groups.fold<int>(0, (sum, group) => sum + group.membersCount);

    final allPhotos = groups
        .expand((group) => group.profilePictures ?? [])
        .whereType<Uint8List>()
        .toSet()
        .toList();

    return (totalMembers, allPhotos);
  }
}
