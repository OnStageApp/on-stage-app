import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:open_file/open_file.dart';

final fileEditingStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class SongFileTile extends ConsumerStatefulWidget {
  const SongFileTile(this.songFile, {super.key});
  final SongFile songFile;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          if (ref.read(fileEditingStateProvider)) {
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

  void _handleEditingToggle(bool currentEditingState) {
    if (currentEditingState) {
      final newName = _controller.text;
      // TODO: Implement rename logic
      // ref.read(songFilesNotifierProvider.notifier).renameFile(widget.songFile, newName);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
    ref.read(fileEditingStateProvider.notifier).update((state) => !state);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(fileEditingStateProvider);
    final isLoading = ref.watch(documentLoadingProvider(widget.songFile.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        splashColor: context.colorScheme.surfaceBright,
        tileColor: context.colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: isEditing
            ? null
            : () {
                // Disable onTap when editing
                if (widget.songFile.fileType == FileTypeEnum.audio) {
                  ref
                      .read(songFilesNotifierProvider.notifier)
                      .openAudioFile(widget.songFile);
                } else {
                  openDocument(widget.songFile);
                }
              },
        visualDensity: VisualDensity.compact,
        title: Row(
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
                    GestureDetector(
                      // Wrap TextField with GestureDetector
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
                    )
                  else
                    Text(
                      widget.songFile.name,
                      style: context.textTheme.titleMedium!.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: context.colorScheme.onSurface,
                    strokeWidth: 2,
                  ),
                ),
              )
            else
              AdaptiveMenuContext(
                items: [
                  MenuAction(
                    icon: LucideIcons.pencil,
                    title: 'Rename',
                    onTap: () => _handleEditingToggle(false),
                  ),
                  MenuAction(
                    icon: LucideIcons.trash,
                    title: 'Remove',
                    onTap: () {},
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
    );
  }

  String _getFileSize() {
    return widget.songFile.size > 1000
        ? '${(widget.songFile.size / 1024).toStringAsFixed(2)} MB'
        : '${widget.songFile.size} KB';
  }

  Future<void> openDocument(SongFile file) async {
    final lowerName = file.name.toLowerCase();
    if (lowerName.endsWith('.pdf')) {
      // Set loading state for this file to true.
      ref.read(documentLoadingProvider(file.id).notifier).state = true;

      final pdfPaths = await ref
          .read(songFilesNotifierProvider.notifier)
          .getLocalPdfPathsForDocument(file);

      // Set loading state to false when done.
      ref.read(documentLoadingProvider(file.id).notifier).state = false;

      if (pdfPaths.isNotEmpty && mounted) {
        // Find the index of the tapped PDF among all PDF files.
        final allPdfFiles = ref
            .read(songFilesNotifierProvider)
            .songFiles
            .where((f) => f.name.toLowerCase().endsWith('.pdf'))
            .toList();
        final tappedIndex = allPdfFiles.indexWhere((f) => f.id == file.id);

        unawaited(
          context.pushNamed(
            AppRoute.pdfPreview.name,
            extra: List<String>.from(pdfPaths),
            queryParameters: {
              'initialIndex': tappedIndex.toString(),
            },
          ),
        );
      }
    } else if (lowerName.endsWith('.ppt') || lowerName.endsWith('.pptx')) {
      await OpenFile.open(file.url);
    } else {
      await OpenFile.open(file.url);
    }
  }
}

final documentLoadingProvider = StateProvider.family<bool, String>(
  (ref, songFileId) => false,
);
