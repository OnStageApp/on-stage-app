import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_request.freezed.dart';
part 'reminder_request.g.dart';

@Freezed()
class ReminderRequest with _$ReminderRequest {
  const factory ReminderRequest({
    required List<int> daysBefore,
    required String? eventId,
  }) = _ReminderRequest;

  factory ReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$ReminderRequestFromJson(json);
}
