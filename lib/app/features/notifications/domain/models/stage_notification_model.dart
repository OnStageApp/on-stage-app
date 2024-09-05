import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage_notification_model.freezed.dart';
part 'stage_notification_model.g.dart';

@Freezed()
class StageNotification with _$StageNotification {
  const factory StageNotification({
    required int id,
    required String title,
    required DateTime dateTime,
    required String createdAt,
    required bool isInvitationConfirmed,
    required bool seen,
    String? friendId,
    String? friendPhotoUrl,
    String? eventId,
  }) = _StageNotification;

  factory StageNotification.fromJson(Map<String, dynamic> json) =>
      _$StageNotificationFromJson(json);
}
