import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_controller_state.freezed.dart';

@freezed
class ReminderControllerState with _$ReminderControllerState {
  const factory ReminderControllerState({
    @Default([]) List<int> selectedReminders,
  }) = _ReminderControllerState;
}
