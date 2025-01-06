import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/application/group_notifier.dart';
import 'package:on_stage_app/app/features/groups/presentation/widgets/add_new_button.dart';
import 'package:on_stage_app/app/features/groups/presentation/widgets/group_card.dart';
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
      ref.watch(groupNotifierProvider.notifier).loadGroups();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupNotifierProvider).groups;
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: groups.length,
          itemBuilder: (_, index) {
            final group = groups[index];
            return GroupCard(
              groupId: group.id,
            );
          },
        ),
      ),
    );
  }
}
