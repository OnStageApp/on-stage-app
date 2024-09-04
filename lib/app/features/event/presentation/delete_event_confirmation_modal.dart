import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeleteEventConfirmationDialog extends ConsumerWidget {
  const DeleteEventConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400), // Set a maximum width
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.priority_high,
                size: 24,
                color: context.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Delete Event',
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Are you sure you want to delete'
              ' ${ref.watch(eventNotifierProvider).event!.name}?',
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ContinueButton(
                    textColor: context.colorScheme.onSurface,
                    backgroundColor: context.colorScheme.surfaceBright,
                    hasShadow: false,
                    text: 'Cancel',
                    onPressed: () => context.popDialog(),
                    isEnabled: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ContinueButton(
                    hasShadow: false,
                    text: 'Delete',
                    onPressed: () {
                      context
                        ..popDialog()
                        ..pushReplacementNamed(AppRoute.events.name);
                      ref.read(eventNotifierProvider.notifier).deleteEvent();
                    },
                    isEnabled: true,
                    backgroundColor: context.colorScheme.error,
                    textColor: context.colorScheme.onError,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> show({required BuildContext context}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const DeleteEventConfirmationDialog(),
    );
  }
}
