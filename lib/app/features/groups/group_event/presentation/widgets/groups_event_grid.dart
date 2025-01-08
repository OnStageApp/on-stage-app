import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/presentation/widgets/group_event_card.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class GroupsEventGrid extends ConsumerStatefulWidget {
  const GroupsEventGrid({
    super.key,
  });

  @override
  ConsumerState<GroupsEventGrid> createState() => _GroupsEventGridState();
}

class _GroupsEventGridState extends ConsumerState<GroupsEventGrid> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupEventNotifierProvider.notifier).getGroupsEvent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupEventNotifierProvider);
    final eventId = ref.watch(eventNotifierProvider).event?.id;
    if (eventId == null) return const SizedBox();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: groupState.isLoading ? 2 : groupState.groupEvents.length,
      itemBuilder: (_, index) {
        if (groupState.isLoading) return _buildShimmerGroupCard(context);
        final group = groupState.groupEvents.elementAt(index);
        return GroupEventCard(
          groupId: group.id,
          eventId: eventId,
        );
      },
    );
  }
}

Widget _buildShimmerGroupCard(BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Shimmer.fromColors(
      baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
      highlightColor: context.colorScheme.onSurfaceVariant,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
