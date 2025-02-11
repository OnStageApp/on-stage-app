import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_state.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/data/group_event_template_repository.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/domain/group_event_template.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_event_template_notifier.g.dart';

@riverpod
class GroupEventTemplateNotifier extends _$GroupEventTemplateNotifier {
  GroupEventTemplateRepository get _groupEventTemplateRepo =>
      ref.read(groupEventTemplateRepo);

  @override
  GroupEventTemplateState build() {
    return const GroupEventTemplateState();
  }

  Future<void> getGroupEventById(String eventTemplateId, String groupId) async {
    state = state.copyWith(error: null);
    try {
      final group =
          await _groupEventTemplateRepo.getGroupById(eventTemplateId, groupId);
      final updatedGroup = await _updateGroupWithPhotos(group);

      state = state.copyWith(
        groups: state.groups
            .map((e) => e.id == groupId ? updatedGroup : e)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    }
  }

  Future<void> getGroupsForEventTemplate(String eventTemplateId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final groups = await _groupEventTemplateRepo.getGroups(eventTemplateId);
      final updatedGroups = await Future.wait(
        groups.map(_updateGroupWithPhotos),
      );

      state = state.copyWith(groups: updatedGroups);
    } catch (e) {
      logger.e('Error getting groups for event $eventTemplateId', e);
      state = state.copyWith(error: e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<GroupEventTemplate> _updateGroupWithPhotos(
    GroupEventTemplate group,
  ) async {
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
    final groups = state.groups;
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
