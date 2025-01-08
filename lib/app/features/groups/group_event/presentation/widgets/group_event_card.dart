import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/positions/position_event/presentation/position_members_modal.dart';
import 'package:on_stage_app/app/features/positions/position_template/presentation/position_modal.dart';
import 'package:on_stage_app/app/shared/square_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GroupEventCard extends ConsumerStatefulWidget {
  const GroupEventCard({
    required this.groupId,
    required this.eventId,
    this.isTemplateEditable = true,
    this.onTap,
    super.key,
  });

  final String groupId;
  final String eventId;
  final bool isTemplateEditable;
  final VoidCallback? onTap;

  @override
  ConsumerState<GroupEventCard> createState() => _GroupEventCardState();
}

class _GroupEventCardState extends ConsumerState<GroupEventCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(groupEventNotifierProvider).groupEvents.firstWhere(
          (group) => group.id == widget.groupId,
          orElse: () => throw StateError('Group not found: ${widget.groupId}'),
        );
    return Card(
      margin: const EdgeInsets.all(6),
      color: context.colorScheme.onSurfaceVariant,
      elevation: 0,
      // Flat design
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => widget.isTemplateEditable ? null : _doActionOnTap(context),
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (group.stagerCount > 0)
                    Expanded(
                      child: ParticipantsOnTile(
                        participantsLength: group.stagerCount,
                        textColor: Colors.white,
                        participantsProfileName: const [],
                        useRandomColors: true,
                        participantsMax: 5,
                      ),
                    )
                  else
                    SquareIconButton(
                      icon: LucideIcons.plus,
                      onPressed: () => _doActionOnTap(context),
                      backgroundColor: context.isDarkMode
                          ? const Color(0xFF43474E)
                          : context.colorScheme.surface,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                group.name,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              _buildSubtitle(group, context),
            ],
          ),
        ),
      ),
    );
  }

  void _doActionOnTap(BuildContext context) {
    widget.isTemplateEditable
        ? PositionModal.show(
            context: context,
            groupId: widget.groupId,
          )
        : PositionMembersModal.show(
            context: context,
            groupId: widget.groupId,
            eventId: widget.eventId,
          );
  }

  Widget _buildSubtitle(GroupEvent group, BuildContext context) {
    return Text(
      '${group.stagerCount} Members',
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }
}
