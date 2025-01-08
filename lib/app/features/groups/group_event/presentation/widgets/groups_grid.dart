import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/groups/group_event/presentation/widgets/group_event_card.dart';

class GroupsEventGrid extends StatelessWidget {
  const GroupsEventGrid({
    required this.groups,
    required this.eventId,
    this.isTemplateEditable = true,
    super.key,
  });

  final List<GroupEvent> groups;
  final String eventId;
  final bool isTemplateEditable;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: groups.length,
      itemBuilder: (_, index) {
        final group = groups[index];
        return GroupEventCard(
          groupId: group.id,
          eventId: eventId,
          isTemplateEditable: isTemplateEditable,
        );
      },
    );
  }
}
