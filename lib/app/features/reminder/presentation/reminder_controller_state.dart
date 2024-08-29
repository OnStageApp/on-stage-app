import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_model.dart';

part 'reminder_controller_state.freezed.dart';

@freezed
class ReminderControllerState with _$ReminderControllerState {
  const factory ReminderControllerState({
    @Default([]) List<int> selectedReminders,
  }) = _ReminderControllerState;
}
