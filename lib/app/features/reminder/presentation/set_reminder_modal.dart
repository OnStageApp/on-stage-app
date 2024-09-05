import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/reminder/presentation/reminder_controller.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SetReminderModal extends ConsumerStatefulWidget {
  const SetReminderModal({
    required this.cacheReminders,
    this.onSaved,
    super.key,
  });

  final void Function(List<int>)? onSaved;

  final List<int> cacheReminders;

  @override
  SetReminderModalState createState() => SetReminderModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required void Function(List<int>) onSaved,
    required List<int> cacheReminders,
    void Function(int)? onSelected,
    void Function(int)? onRemoved,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Alert Options'),
        buildFooter: () => Container(
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: ContinueButton(
            text: 'Save',
            onPressed: () {
              onSaved.call(
                ref.read(reminderControllerProvider).selectedReminders,
              );
              context.popDialog();
            },
            isEnabled: true,
          ),
        ),
        headerHeight: () => 64,
        footerHeight: () => 64,
        buildContent: () {
          return SingleChildScrollView(
            child: SetReminderModal(
              onSaved: onSaved,
              cacheReminders: cacheReminders,
            ),
          );
        },
      ),
    );
  }
}

class SetReminderModalState extends ConsumerState<SetReminderModal> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reminderControllerProvider.notifier).setReminders(
            widget.cacheReminders,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(reminderControllerProvider).selectedReminders;
    return Padding(
      padding: defaultScreenPadding,
      child: ListView.builder(
        itemCount: _defaultReminders.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildAlert(
                _defaultReminders[index].toString(),
                () {
                  _setReminders(_defaultReminders[index]);
                },
                isSelected: reminders.contains(_defaultReminders[index]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: index == 0 ? 12 : 6),
                child:
                    index == 0 ? const DashedLineDivider() : const SizedBox(),
              ),
              if (index == _defaultReminders.length - 1)
                const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  void _setReminders(int daysBeforeEvent) {
    final controller = ref.read(reminderControllerProvider.notifier);
    final currentReminders =
        ref.watch(reminderControllerProvider).selectedReminders;

    if (daysBeforeEvent == 0) {
      controller
        ..clearAllReminders()
        ..addReminder(0);
    } else {
      if (currentReminders.contains(daysBeforeEvent)) {
        controller.removeReminder(daysBeforeEvent);
        if (currentReminders.length == 1) {
          controller.addReminder(0);
        }
      } else {
        if (currentReminders.contains(0)) {
          controller.removeReminder(0);
        }
        controller.addReminder(daysBeforeEvent);
      }
    }
  }

  Widget _buildAlert(
    String daysBefore,
    void Function() onTap, {
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? context.colorScheme.primary : Colors.transparent,
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            Text(
              daysBefore == '0' ? 'None' : '$daysBefore days before',
              style: context.textTheme.titleMedium,
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colorScheme.primary,
                size: 20,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: context.colorScheme.surfaceBright,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  final List<int> _defaultReminders = [
    0,
    1,
    3,
    7,
    14,
  ];
}
