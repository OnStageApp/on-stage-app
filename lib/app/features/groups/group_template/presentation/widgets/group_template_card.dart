import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/providers/group_card_template_provider.dart';
import 'package:on_stage_app/app/features/positions/position_template/presentation/position_modal.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/square_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GroupTemplateCard extends ConsumerStatefulWidget {
  const GroupTemplateCard({
    required this.groupId,
    this.onTap,
    super.key,
  });

  final String groupId;
  final VoidCallback? onTap;

  @override
  ConsumerState<GroupTemplateCard> createState() => _GroupTemplateCardState();
}

class _GroupTemplateCardState extends ConsumerState<GroupTemplateCard> {
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
      final state = ref.watch(groupTemplateProvider(widget.groupId));
      if (state.isEditing) {
        ref
            .read(groupTemplateProvider(widget.groupId).notifier)
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
    final state = ref.watch(groupTemplateProvider(widget.groupId));
    final group = state.group;

    if (state.isEditing && _controller.text != group.name) {
      _controller.text = group.name;
      _focusNode.requestFocus();
    }

    return Card(
      margin: const EdgeInsets.all(6),
      color: context.colorScheme.onSurfaceVariant,
      elevation: 0,
      // Flat design
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
                  onPressed: () => PositionModal.show(
                    context: context,
                    groupId: widget.groupId,
                  ),
                  backgroundColor: context.isDarkMode
                      ? const Color(0xFF43474E)
                      : context.colorScheme.surface,
                ),
                AdaptiveMenuContext(
                  items: [
                    MenuAction(
                      title: 'Rename',
                      onTap: () => ref
                          .read(groupTemplateProvider(widget.groupId).notifier)
                          .startEditing(),
                      icon: Icons.edit,
                    ),
                    MenuAction(
                      title: 'Delete',
                      onTap: () => ref
                          .read(groupTemplateProvider(widget.groupId).notifier)
                          .deleteGroup(),
                      icon: Icons.delete_outline,
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
            if (state.isEditing)
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: context.textTheme.titleMedium,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (value) => ref
                    .read(groupTemplateProvider(widget.groupId).notifier)
                    .stopEditingAndSave(value),
              )
            else
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
    );
  }

  Widget _buildSubtitle(GroupTemplateModel group, BuildContext context) {
    return Text(
      '${group.positionsCount} Positions',
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }
}
