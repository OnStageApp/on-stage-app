import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@Freezed()
class StageNotification with _$StageNotification {
  const factory StageNotification({
    required String notificationId,
    required String description,
    DateTime? dateTime,
    String? createdAt,
    bool? isInvitationConfirmed,
    NotificationStatus? status,
    NotificationType? type,
    String? friendId,
    String? friendPhotoUrl,
    String? eventId,
  }) = _StageNotification;

  factory StageNotification.fromJson(Map<String, dynamic> json) =>
      _$StageNotificationFromJson(json);
}
