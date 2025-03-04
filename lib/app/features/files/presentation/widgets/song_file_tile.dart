import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/files/file_manager.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/file_size_calculator.dart';

final fileEditingStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class SongFileTile extends ConsumerStatefulWidget {
  const SongFileTile(this.songFile, this.songId, {super.key});
  final SongFile songFile;
  final String songId;

  @override
  ConsumerState<SongFileTile> createState() => _SongFileTileState();
}

class _SongFileTileState extends ConsumerState<SongFileTile> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.songFile.name);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && ref.read(fileEditingStateProvider)) {
        _toggleEditMode();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    final currentEditingState = ref.read(fileEditingStateProvider);
    if (currentEditingState) {
      final newName = _controller.text;
      if (newName.isNotEmpty && newName != widget.songFile.name) {
        ref
            .read(songFilesNotifierProvider.notifier)
            .renameSongFile(widget.songFile.id, newName);
      }
    } else {
      _focusNode.requestFocus();
    }
    ref.read(fileEditingStateProvider.notifier).update((state) => !state);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(fileEditingStateProvider);
    final fileManagerState = ref.watch(fileManagerProvider);
    final isLoading = fileManagerState.isLoading(widget.songFile.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => isLoading ? null : _openFile(context, isEditing),
            overlayColor:
                WidgetStateProperty.all(context.colorScheme.surfaceBright),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    widget.songFile.fileType.icon,
                    size: 24,
                    color: widget.songFile.fileType.iconColor(),
                  ),
                  const SizedBox(width: Insets.smallNormal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditing)
                          _buildEditingTile()
                        else
                          _buildNonEditingTile(),
                        Text(
                          _getFileSize(),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      padding: const EdgeInsets.all(6),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFF43474E)
                            : context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const SizedBox(
                        child: StgLoadingIndicator(
                          size: 16,
                        ),
                      ),
                    )
                  else
                    AdaptiveMenuContext(
                      items: [
                        MenuAction(
                          icon: LucideIcons.pencil,
                          title: 'Rename',
                          onTap: _toggleEditMode,
                        ),
                        MenuAction(
                          icon: LucideIcons.trash,
                          title: 'Remove',
                          onTap: () {
                            ref
                                .read(songFilesNotifierProvider.notifier)
                                .deleteSongFile(widget.songFile.id);
                          },
                          isDestructive: true,
                        ),
                      ],
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? const Color(0xFF43474E)
                              : context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(
                          LucideIcons.ellipsis_vertical,
                          size: 15,
                          color: Color(0xFF8E9199),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditingTile() {
    return GestureDetector(
      onTap: () {}, // Empty onTap to prevent tap propagation
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: context.textTheme.titleMedium!.copyWith(
          color: context.colorScheme.onSurface,
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNonEditingTile() {
    return Text(
      widget.songFile.name,
      style: context.textTheme.titleMedium!.copyWith(
        color: context.colorScheme.onSurface,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _openFile(BuildContext context, bool isEditing) async {
    final isLoading =
        ref.watch(fileManagerProvider).isLoading(widget.songFile.id);
    if (isEditing || isLoading) {
      return;
    }
    await ref
        .read(fileManagerProvider.notifier)
        .openFile(widget.songFile, context);
  }

  String _getFileSize() {
    return FileSizeCalculator.formatSize(widget.songFile.size);
  }
}
