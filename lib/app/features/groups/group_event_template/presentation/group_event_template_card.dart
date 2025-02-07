import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/domain/group_event_template.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/group_obj_card.dart';

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
    );
  }
}

class _GroupEventTemplateCardContent extends GroupObjCard {
  _GroupEventTemplateCardContent({
    required this.group,
  }) : super(groupId: group.id);

  final GroupEventTemplate group;

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
  void handleTap(BuildContext context, WidgetRef ref) {
    print('GroupEventTemplateCard tapped');
  }
}
