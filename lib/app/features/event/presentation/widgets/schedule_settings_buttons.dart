import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/shared/edit_save_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ScheduleSettingsButtons extends ConsumerWidget {
  const ScheduleSettingsButtons({
    required this.onPlayTap,
    required this.onEditTap,
    required this.isEditMode,
    super.key,
  });

  final VoidCallback onPlayTap;
  final VoidCallback onEditTap;
  final bool isEditMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          if (!isEditMode) ...[
            _PlayButton(onTap: onPlayTap),
            const SizedBox(width: 8),
          ],
          if (ref.watch(permissionServiceProvider).hasAccessToEdit)
            EditSaveButton(
              onTap: onEditTap,
              isEditMode: isEditMode,
            ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 32,
        child: InkWell(
          onTap: onTap,
          overlayColor: WidgetStatePropertyAll(
            context.colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.play,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  'Start',
                  style: context.textTheme.labelMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
