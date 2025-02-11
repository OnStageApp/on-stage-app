import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/domain/group_event_template.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/group_obj_card.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_members_modal.dart';

class GroupEventTemplateCard extends ConsumerWidget {
  const GroupEventTemplateCard({
    required this.groupId,
    required this.eventTemplateId,
    super.key,
  });

  final String groupId;
  final String eventTemplateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group =
        ref.watch(groupEventTemplateNotifierProvider).groups.firstWhere(
              (group) => group.id == groupId,
              orElse: () => throw StateError('Group not found: $groupId'),
            );

    return _GroupEventTemplateCardContent(
      group: group,
      eventTemplateId: eventTemplateId,
    );
  }
}

class _GroupEventTemplateCardContent extends GroupObjCard {
  _GroupEventTemplateCardContent({
    required this.group,
    required this.eventTemplateId,
  }) : super(groupId: group.id);

  final GroupEventTemplate group;
  final String eventTemplateId;

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
    return buildDefaultSubtitle(
      context,
      '${group.membersCount} Members',
    );
  }

  @override
  Future<void> handleTap(BuildContext context, WidgetRef ref) async {
    await PositionMembersModal.show(
      context: context,
      groupId: groupId,
      eventTemplateId: eventTemplateId,
    );

    if (!context.mounted) return;

    unawaited(
      ref
          .read(groupEventTemplateNotifierProvider.notifier)
          .getGroupEventById(eventTemplateId, groupId),
    );
  }
}
