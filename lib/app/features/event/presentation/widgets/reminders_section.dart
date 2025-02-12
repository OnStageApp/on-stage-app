import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/reminder/application/reminder_notifier.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_model.dart';
import 'package:on_stage_app/app/features/reminder/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class RemindersSection extends ConsumerStatefulWidget {
  const RemindersSection({super.key});

  @override
  ConsumerState<RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends ConsumerState<RemindersSection> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadInitialReminders());
  }

  void _loadInitialReminders() {
    final event = ref.read(eventNotifierProvider).event;
    if (event != null) {
      ref.read(reminderNotifierProvider.notifier).getReminders(event.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final remindersState = ref.watch(reminderNotifierProvider);
    final event = ref.watch(eventNotifierProvider).event;

    if (!_areRemindersEqual(_reminders, remindersState.reminders)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAnimatedList(remindersState.reminders);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reminders', style: context.textTheme.titleSmall),
        const SizedBox(height: Insets.smallNormal),
        _buildAnimatedList(),
        EventActionButton(
          onTap: () => _showSetReminderModal(context, event),
          text: 'Edit Reminders',
          icon: LucideIcons.bell_dot,
        ),
      ],
    );
  }

  Widget _buildAnimatedList() {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _reminders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final reminder = _reminders[index];
        return _buildAnimatedItem(reminder, animation);
      },
    );
  }

  Widget _buildAnimatedItem(Reminder reminder, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomSettingTile(
            backgroundColor: context.colorScheme.onSurfaceVariant,
            placeholder: 'Alert ${_reminders.indexOf(reminder) + 1}',
            suffix: Text(
              '${reminder.daysBefore} days before',
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  void _showSetReminderModal(BuildContext context, EventModel? event) {
    ref.watch(permissionServiceProvider).callMethodIfHasPermission(
          context: context,
          permissionType: PermissionType.reminders,
          onGranted: () {
            SetReminderModal.show(
              context: context,
              cacheReminders: _reminders.map((e) => e.daysBefore).toList(),
              ref: ref,
              onSaved: (updatedReminders) {
                if (event != null) {
                  ref
                      .read(reminderNotifierProvider.notifier)
                      .createReminders(updatedReminders, event.id ?? '');
                }
              },
            );
          },
        );
  }

  void _updateAnimatedList(List<Reminder> newReminders) {
    if (_reminders.isEmpty && newReminders.isEmpty) {
      // Both lists are empty, nothing to do
      return;
    }

    if (_reminders.isNotEmpty && newReminders.isEmpty) {
      // Remove all reminders
      for (var i = _reminders.length - 1; i >= 0; i--) {
        _removeReminderAtIndex(i);
      }
      return;
    }

    final oldLength = _reminders.length;
    final newLength = newReminders.length;

    // Update list
    for (var i = 0; i < max(oldLength, newLength); i++) {
      if (i >= newLength) {
        _removeReminderAtIndex(i);
      } else if (i >= oldLength) {
        _insertReminderAtIndex(i, newReminders[i]);
      } else if (_reminders[i].daysBefore != newReminders[i].daysBefore) {
        _replaceReminderAtIndex(i, newReminders[i]);
      }
    }

    _reminders = List.from(newReminders);
  }

  void _removeReminderAtIndex(int index) {
    if (index < 0 || index >= _reminders.length) return;
    final removedItem = _reminders.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedItem(removedItem, animation),
    );
  }

  void _insertReminderAtIndex(int index, Reminder newReminder) {
    _reminders.insert(index, newReminder);
    _listKey.currentState?.insertItem(index);
  }

  void _replaceReminderAtIndex(int index, Reminder newReminder) {
    _removeReminderAtIndex(index);
    _insertReminderAtIndex(index, newReminder);
  }

  bool _areRemindersEqual(List<Reminder> list1, List<Reminder> list2) {
    return list1.length == list2.length &&
        list1.asMap().entries.every(
              (entry) => entry.value.daysBefore == list2[entry.key].daysBefore,
            );
  }
}
