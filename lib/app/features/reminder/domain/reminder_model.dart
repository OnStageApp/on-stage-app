import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@Freezed()
class Reminder with _$Reminder {
  const factory Reminder({
    required int daysBefore,
    required bool isSent,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
