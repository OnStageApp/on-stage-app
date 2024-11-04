import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@Freezed()
class StageNotification with _$StageNotification {
  const factory StageNotification({
    required String notificationId,
    required String description,
    NotificationStatus? status,
    NotificationActionStatus? actionStatus,
    NotificationType? type,
    String? eventId,
    String? stagerId,
    List<String>? usedIdsWithPhoto,
    DateTime? dateTime,
  }) = _StageNotification;

  factory StageNotification.fromJson(Map<String, dynamic> json) =>
      _$StageNotificationFromJson(json);
}
