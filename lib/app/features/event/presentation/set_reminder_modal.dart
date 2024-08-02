import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/reminder/reminder_enum.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SetReminderModal extends ConsumerStatefulWidget {
  const SetReminderModal({
    super.key,
  });

  @override
  SetReminderModalState createState() => SetReminderModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Alert Options'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: SetReminderModal(),
          );
        },
      ),
    );
  }
}

class SetReminderModalState extends ConsumerState<SetReminderModal> {
  List<int> selectedReminders = [1];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: ListView.builder(
        itemCount: reminders.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildAlert(
                reminders[index].name ?? '',
                () {
                  _editReminders(index);
                },
                isSelected: selectedReminders.contains(index),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: index == 0 ? 12 : 6),
                child:
                    index == 0 ? const DashedLineDivider() : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editReminders(int index) {
    setState(() {
      if (index == ReminderEnum.none.index) {
        selectedReminders
          ..clear()
          ..add(index);
      } else {
        if (selectedReminders.contains(index)) {
          selectedReminders.remove(index);
        } else {
          selectedReminders
            ..remove(ReminderEnum.none.index)
            ..add(index);
        }
      }
    });
  }

  Widget _buildAlert(
    String name,
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
              name,
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

  List<ReminderEnum> reminders = ReminderEnum.values;
}
