import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/widgets/groups_grid.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  GroupsScreenState createState() => GroupsScreenState();
}

class GroupsScreenState extends ConsumerState<GroupsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupTemplateNotifierProvider.notifier).getGroupsTemplate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupTemplateNotifierProvider).groups;
    return Scaffold(
      appBar: StageAppBar(
        title: 'Groups',
        isBackButtonVisible: true,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AddNewButton(
            onPressed: () {},
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GroupsTemplateGrid(
          groups: groups,
        ),
      ),
    );
  }
}
