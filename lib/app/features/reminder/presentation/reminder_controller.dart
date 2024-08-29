import 'package:on_stage_app/app/features/reminder/presentation/reminder_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_controller.g.dart';

@riverpod
class ReminderController extends _$ReminderController {
  @override
  ReminderControllerState build() {
    return const ReminderControllerState();
  }

  void setReminders(List<int> reminders) {
    state = state.copyWith(selectedReminders: reminders);
  }

  void addReminder(int daysBeforeEvent) {
    state = state.copyWith(
      selectedReminders: [
        ...state.selectedReminders,
        daysBeforeEvent,
      ],
    );
  }

  void removeReminder(int daysBeforeEvent) {
    state = state.copyWith(
      selectedReminders: state.selectedReminders
          .where((daysBeforeEventUpdated) =>
              daysBeforeEventUpdated != daysBeforeEvent)
          .toList(),
    );
  }

  void clearAllReminders() {
    state = state.copyWith(selectedReminders: []);
  }
}
