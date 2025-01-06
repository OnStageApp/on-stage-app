import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/presentation/providers/group_card_provider.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_modal.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/square_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GroupCard extends ConsumerStatefulWidget {
  const GroupCard({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  ConsumerState<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends ConsumerState<GroupCard> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      final state = ref.watch(groupCardProvider(widget.groupId));
      if (state.isEditing) {
        ref
            .read(groupCardProvider(widget.groupId).notifier)
            .stopEditingAndSave(_controller.text);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupCardProvider(widget.groupId));
    final group = state.group;

    if (state.isEditing && _controller.text != group.title) {
      _controller.text = group.title;
      _focusNode.requestFocus();
    }

    return Card(
      color: context.colorScheme.onSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SquareIconButton(
                  icon: LucideIcons.plus,
                  onPressed: () {
                    PositionModal.show(
                      context: context,
                      groupId: widget.groupId,
                    );
                  },
                  backgroundColor: context.isDarkMode
                      ? const Color(0xFF43474E)
                      : context.colorScheme.surface,
                ),
                AdaptiveMenuContext(
                  items: [
                    MenuAction(
                      title: 'Rename',
                      onTap: () => ref
                          .read(groupCardProvider(widget.groupId).notifier)
                          .startEditing(),
                      icon: Icons.edit,
                    ),
                    MenuAction(
                      title: 'Delete',
                      onTap: () => ref
                          .read(groupCardProvider(widget.groupId).notifier)
                          .deleteGroup(),
                      icon: Icons.delete,
                      isDestructive: true,
                    ),
                  ],
                  child: Icon(
                    LucideIcons.ellipsis_vertical,
                    color: context.colorScheme.outline,
                    size: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              child: state.isEditing
                  ? TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: context.textTheme.titleMedium,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (value) => ref
                          .read(groupCardProvider(widget.groupId).notifier)
                          .stopEditingAndSave(value),
                    )
                  : Text(
                      group.title,
                      style: context.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Text(
              '${group.positionsLength} Positions',
              style: context.textTheme.bodyMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
