import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';

final editingStateProvider = StateProvider.autoDispose<bool>((ref) => false);

class SongNotesCard extends ConsumerStatefulWidget {
  const SongNotesCard({
    required this.songId,
    required this.tempo,
    required this.leads,
    required this.notes,
    required this.onNotesChanged,
    super.key,
  });

  final String? songId;
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

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.notes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          if (ref.read(editingStateProvider)) {
            _handleEditingToggle(true);
          }
        }
      });
    });
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
    ref
        .read(songNotifierProvider(widget.songId).notifier)
        .updateSongMdNotes('');
  }

  void _handleEditingToggle(bool currentEditingState) {
    if (currentEditingState) {
      final mdNotes = _controller.text;
      logger.i('saving notes $mdNotes');
      ref
          .read(songNotifierProvider(widget.songId).notifier)
          .updateSongMdNotes(mdNotes);
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
      // width: 24,
      // height: 24,
      items: menuItems,
      child: SizedBox(
        height: 30,
        width: 30,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: colorScheme.surface,
          ),
          child: Icon(
            LucideIcons.ellipsis_vertical,
            size: 15,
            color: colorScheme.outline,
          ),
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
              style: _getFontSize(textTheme),
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
                  : 'No MD notes added',
              style: textTheme.titleLarge?.copyWith(
                fontSize: ref
                        .watch(userSettingsNotifierProvider)
                        .textSize
                        ?.size(context) ??
                    (TextSize.small.size(context)),
                color: widget.notes.isNotNullEmptyOrWhitespace
                    ? colorScheme.surfaceContainer
                    : colorScheme.surfaceContainer.withAlpha(100),
              ),
            ),
    );
  }

  TextStyle _getFontSize(TextTheme textTheme) {
    return textTheme.titleLarge!.copyWith(
      fontSize:
          ref.watch(userSettingsNotifierProvider).textSize?.size(context) ??
              (TextSize.normal.size(context)),
    );
  }

  Widget _buildInfoSection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tempo: ${widget.tempo}',
          style: _getFontSize(textTheme)
              .copyWith(color: colorScheme.surfaceContainer),
        ),
        if (widget.leads.isNotNullOrEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Leads: ${widget.leads!.join(', ')}',
            style: _getFontSize(textTheme).copyWith(
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (ref.read(editingStateProvider)) {
          _handleEditingToggle(true);
        }
      },
      child: Container(
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
      ),
    );
  }
}
