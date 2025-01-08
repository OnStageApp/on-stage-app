import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/widgets/group_template_card.dart';

class GroupsTemplateGrid extends StatelessWidget {
  const GroupsTemplateGrid({
    required this.groups,
    super.key,
  });

  final List<GroupTemplateModel> groups;

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
        return GroupTemplateCard(
          groupId: group.id,
        );
      },
    );
  }
}
