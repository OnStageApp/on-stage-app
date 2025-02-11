import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/presentation/widgets/group_event_card.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/presentation/group_event_template_card.dart';
import 'package:on_stage_app/app/features/groups/shared/domain/group_base.dart';
import 'package:on_stage_app/app/features/groups/shared/enums/group_grid_type.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class GroupsObjGrid extends ConsumerWidget {
  const GroupsObjGrid.fromEventId({
    required String eventId,
    super.key,
  })  : _eventId = eventId,
        _eventTemplateId = null,
        _type = GroupGridType.event;

  const GroupsObjGrid.fromEventTemplateId({
    required String? eventTemplateId,
    super.key,
  })  : _eventTemplateId = eventTemplateId,
        _eventId = null,
        _type = GroupGridType.eventTemplate;

  final String? _eventId;
  final String? _eventTemplateId;
  final GroupGridType _type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _GroupsObjGridContent(
      type: _type,
      eventId: _eventId,
      eventTemplateId: _eventTemplateId,
    );
  }
}

class _GroupsObjGridContent extends ConsumerWidget {
  const _GroupsObjGridContent({
    required this.type,
    required this.eventId,
    required this.eventTemplateId,
  });

  final GroupGridType type;
  final String? eventId;
  final String? eventTemplateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = switch (type) {
      GroupGridType.event => ref.watch(groupEventNotifierProvider).isLoading,
      GroupGridType.eventTemplate =>
        ref.watch(groupEventTemplateNotifierProvider).isLoading,
    };

    final groups = switch (type) {
      GroupGridType.event =>
        ref.watch(groupEventNotifierProvider).groupEvents.cast<GroupBase>(),
      GroupGridType.eventTemplate =>
        ref.watch(groupEventTemplateNotifierProvider).groups.cast<GroupBase>(),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getGridCount(constraints.maxWidth),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: isLoading ? 2 : groups.length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const _ShimmerGroupCard();
            }

            final group = groups.elementAt(index);
            return _buildGroupCard(group.id);
          },
        );
      },
    );
  }

  Widget _buildGroupCard(String groupId) {
    return switch (type) {
      GroupGridType.event => GroupEventCard(
          groupId: groupId,
          eventId: eventId ?? '',
        ),
      GroupGridType.eventTemplate => GroupEventTemplateCard(
          groupId: groupId,
          eventTemplateId: eventTemplateId ?? '',
        ),
    };
  }

  int _getGridCount(double maxWidth) {
    if (maxWidth > 800) return 4;
    if (maxWidth > 600) return 3;
    return 2;
  }
}

class _ShimmerGroupCard extends StatelessWidget {
  const _ShimmerGroupCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Shimmer.fromColors(
        baseColor: context.colorScheme.onSurfaceVariant.withAlpha(10),
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
}
