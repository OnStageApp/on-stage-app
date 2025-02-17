import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongFileTile extends ConsumerWidget {
  const SongFileTile(this.songFile, {super.key});
  final SongFile songFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          if (songFile.fileType == FileTypeEnum.audio) {
            ref
                .read(songFilesNotifierProvider.notifier)
                .openAudioFile(songFile);
          } else {}
        },
        borderRadius: BorderRadius.circular(8),
        overlayColor: WidgetStateProperty.all(
          context.colorScheme.surfaceBright,
        ),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                LucideIcons.chart_no_axes_column,
                size: 24,
                color: context.colorScheme.outline,
              ),
              const SizedBox(width: Insets.smallNormal),
              const SizedBox(width: Insets.smallNormal),
              Text(
                songFile.name,
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              AdaptiveMenuContext(
                items: [
                  MenuAction(
                    icon: LucideIcons.pencil,
                    title: 'Rename',
                    onTap: () {},
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
      ),
    );
  }
}
