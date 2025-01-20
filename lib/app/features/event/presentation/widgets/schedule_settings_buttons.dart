import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
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
            _EditButton(
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
                Icon(
                  LucideIcons.play,
                  size: 16,
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Text(
                  'Start',
                  style: context.textTheme.labelMedium!.copyWith(
                    color: context.colorScheme.onSurface,
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

class _EditButton extends StatelessWidget {
  const _EditButton({
    required this.onTap,
    required this.isEditMode,
  });

  final VoidCallback onTap;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStatePropertyAll(context.colorScheme.surfaceBright),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEditMode
                ? context.colorScheme.outline
                : context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Icon(
              LucideIcons.pencil,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
