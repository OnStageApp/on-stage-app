import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/group_obj_card.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_members_modal.dart';

class GroupEventCard extends ConsumerWidget {
  const GroupEventCard({
    required this.groupId,
    required this.eventId,
    super.key,
  });

  final String groupId;
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupEventNotifierProvider).groupEvents.firstWhere(
          (group) => group.id == groupId,
          orElse: () => throw StateError('Group not found: $groupId'),
        );

    return _GroupEventCardContent(
      group: group,
      eventId: eventId,
    );
  }
}

class _GroupEventCardContent extends GroupObjCard {
  _GroupEventCardContent({
    required this.group,
    required this.eventId,
  }) : super(groupId: group.id);

  final GroupEvent group;
  final String eventId;

  @override
  Widget buildParticipantsSection(BuildContext context, WidgetRef ref) {
    return buildDefaultParticipantsSection(context, ref, group);
  }

  @override
  Widget buildGroupName(BuildContext context) {
    return buildDefaultGroupName(context, group.name);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentEvent = ref.watch(eventNotifierProvider).event;
        final subtitle = currentEvent?.eventStatus == EventStatus.published &&
                group.membersCount > 0
            ? '${group.confirmedCount}/${group.membersCount} Confirmed'
            : '${group.membersCount} Members';

        return buildDefaultSubtitle(context, subtitle);
      },
    );
  }

  @override
  Future<void> handleTap(BuildContext context, WidgetRef ref) async {
    await PositionMembersModal.show(
      context: context,
      groupId: groupId,
      eventId: eventId,
    );

    if (!context.mounted) return;

    unawaited(
      ref
          .read(groupEventNotifierProvider.notifier)
          .getGroupEventById(eventId, groupId),
    );
  }
}
