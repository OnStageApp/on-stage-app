import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/reminder/domain/reminder_model.dart';

part 'reminder_state.freezed.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState({
    @Default([]) List<Reminder> reminders,
  }) = _ReminderState;
}
