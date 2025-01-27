import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';

final editingStateProvider = StateProvider.autoDispose<bool>((ref) => false);

class SongNotesCard extends ConsumerStatefulWidget {
  const SongNotesCard({
    required this.tempo,
    required this.leads,
    required this.notes,
    required this.onNotesChanged,
    super.key,
  });

  final String tempo;
  final List<String>? leads;
  final String? notes;
  final void Function(String) onNotesChanged;

  @override
  ConsumerState<SongNotesCard> createState() => _SongNotesCardCardState();
}

class _SongNotesCardCardState extends ConsumerState<SongNotesCard> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  List<String>? get currentStagersNames {
    final index = ref.watch(eventItemsNotifierProvider).currentIndex;
    final eventItems = ref.watch(eventItemsNotifierProvider).eventItems;
    final eventItemsLength = eventItems.length;
    if (eventItemsLength <= 0) return null;

    return eventItems[index].assignedTo?.map((stager) => stager.name).toList();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SongNotesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != null && widget.notes != oldWidget.notes) {
      _controller.text = widget.notes!;
    }
  }

  void _handleOnDelete() {
    logger.i('deleting notes');
    ref.read(songNotifierProvider.notifier).updateSongMdNotes('');
  }

  void _handleEditingToggle(bool currentEditingState) {
    if (currentEditingState && _controller.text.isNotEmpty) {
      final mdNotes = _controller.text;
      logger.i('saving notes $mdNotes');
      ref.read(songNotifierProvider.notifier).updateSongMdNotes(mdNotes);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
    ref.read(editingStateProvider.notifier).update((state) => !state);
  }

  Widget _buildContextMenu(bool isEditing, ColorScheme colorScheme) {
    if (isEditing) {
      return InkWell(
        onTap: () => _handleEditingToggle(isEditing),
        overlayColor: WidgetStatePropertyAll(colorScheme.surfaceBright),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            LucideIcons.save,
            size: 18,
            color: Colors.white,
          ),
        ),
      );
    }

    final hasNotes = widget.notes.isNotNullEmptyOrWhitespace;
    final menuItems = <MenuAction>[
      MenuAction(
        title: 'Edit',
        onTap: () => _handleEditingToggle(false),
        icon: LucideIcons.pencil,
      ),
    ];
    if (hasNotes) {
      menuItems.addAll([
        MenuAction(
          title: 'Remove',
          onTap: _handleOnDelete,
          icon: LucideIcons.trash_2,
          isDestructive: true,
        ),
      ]);
    }

    return AdaptiveMenuContext(
      width: 24,
      items: menuItems,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          LucideIcons.ellipsis_vertical,
          color: colorScheme.outline,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildMDNotesSection(
    bool isEditing,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 4),
      child: isEditing
          ? TextField(
              focusNode: _focusNode,
              controller: _controller,
              style: textTheme.titleLarge,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              maxLines: null,
              onChanged: widget.onNotesChanged,
            )
          : Text(
              widget.notes.isNotNullEmptyOrWhitespace
                  ? widget.notes!
                  : 'No MD notes added...',
              style: textTheme.titleLarge?.copyWith(
                color: widget.notes.isNotNullEmptyOrWhitespace
                    ? colorScheme.surfaceContainer
                    : colorScheme.surfaceContainer.withOpacity(0.5),
              ),
            ),
    );
  }

  Widget _buildInfoSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tempo: ${widget.tempo}',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.surfaceContainer,
          ),
        ),
        if (currentStagersNames.isNotNullOrEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Leads: ${currentStagersNames!.join(', ')}',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.surfaceContainer,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(editingStateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayMdNotes =
        ref.watch(userSettingsNotifierProvider).displayMdNotes ?? false;
    final displaySongDetails =
        ref.watch(userSettingsNotifierProvider).displaySongDetails ?? false;
    if (!displayMdNotes && !displaySongDetails) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.onSurfaceVariant.withOpacity(0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (displayMdNotes)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMDNotesSection(isEditing, textTheme, colorScheme),
                    ],
                  ),
                ),
                if (ref.watch(permissionServiceProvider).hasAccessToEdit)
                  _buildContextMenu(isEditing, colorScheme),
              ],
            ),
          if (displaySongDetails && displayMdNotes) ...[
            const SizedBox(height: 8),
            DashedLineDivider(color: colorScheme.outline),
            const SizedBox(height: 8),
          ],
          if (displaySongDetails) _buildInfoSection(textTheme, colorScheme),
        ],
      ),
    );
  }
}
