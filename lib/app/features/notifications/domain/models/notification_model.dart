import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_params.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@Freezed()
class StageNotification with _$StageNotification {
  const factory StageNotification({
    required String notificationId,
    String? title,
    String? description,
    NotificationStatus? status,
    NotificationActionStatus? actionStatus,
    NotificationType? type,
    NotificationParams? params,
    String? userToNotifyId,
    @Default([])
    @JsonKey(includeFromJson: false)
    List<Uint8List> profilePictures,
  }) = _StageNotification;

  factory StageNotification.fromJson(Map<String, dynamic> json) =>
      _$StageNotificationFromJson(json);
}
