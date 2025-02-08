import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/reminder/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class RemindersList extends ConsumerWidget {
  const RemindersList({
    required this.reminders,
    required this.onRemindersChanged,
    super.key,
  });

  final List<int> reminders;
  final void Function(List<int>) onRemindersChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminders',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: Insets.smallNormal),
        ListView.builder(
          itemCount: reminders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            if (reminder == 0) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomSettingTile(
                backgroundColor: context.colorScheme.onSurfaceVariant,
                placeholder: 'Alert ${reminders.indexOf(reminder) + 1}',
                placeholderColor: context.colorScheme.onSurface,
                suffix: Text(
                  '$reminder days before',
                  style: context.textTheme.titleMedium!
                      .copyWith(color: context.colorScheme.onSurface),
                ),
              ),
            );
          },
        ),
        EventActionButton(
          text: ' Select Reminders',
          icon: Icons.notification_add_outlined,
          onTap: () => _editReminders(context, ref),
        ),
      ],
    );
  }

  void _editReminders(BuildContext context, WidgetRef ref) {
    SetReminderModal.show(
      cacheReminders: reminders,
      context: context,
      ref: ref,
      onSaved: onRemindersChanged,
    );
  }
}
