import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeleteEventConfirmationDialog extends ConsumerWidget {
  const DeleteEventConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 200,
          minHeight: 200,
          maxHeight: 250,
        ), // Set a maximum width

        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Event',
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Are you sure you want to delete'
                ' ${ref.watch(eventNotifierProvider).event!.name}?',
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Center(
                        child: Text(
                          'Not Now',
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: context.colorScheme.surfaceDim),
                        ),
                      ),
                      onTap: () => context.popDialog(),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Center(
                        child: Text(
                          'Delete',
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      onTap: () async {
                        await ref
                            .read(eventNotifierProvider.notifier)
                            .deleteEventAndGetAll();
                        context
                          ..popDialog()
                          ..pushReplacementNamed(AppRoute.events.name);
                      },
                    ),
                  ),
                ],
              ),
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
