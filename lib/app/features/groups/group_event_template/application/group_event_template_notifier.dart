import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/groups/group_event/data/group_event_repository.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_event_template_notifier.g.dart';

@riverpod
class GroupEventTemplateNotifier extends _$GroupEventTemplateNotifier {
  GroupEventRepository get _groupEventRepo => ref.read(groupEventRepoProvider);

  @override
  GroupEventTemplateState build() {
    return const GroupEventTemplateState();
  }

  Future<void> getGroupsForEventTemplate(String eventTemplateId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      //TODO: implement getGroupsForEventTemplate
      // final groups =
      //     await _groupEventRepo.getGroupsForEventTemplate(eventTemplateId);
      // final updatedGroups = await Future.wait(
      //   groups.map(_updateGroupWithPhotos),
      // );

      //TODO: or add familly provider, or another field groupEventsForEventTemplate or anotherProvider
      // state = state.copyWith(groupEvents: updatedGroups);
    } catch (e) {
      // logger.e('Error getting groups for event $eventId', e);
      state = state.copyWith(error: e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
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
    final groups = state.groupEventTemplates;
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
