import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';

part 'notification_notifier_state.freezed.dart';

@freezed
class NotificationNotifierState with _$NotificationNotifierState {
  const factory NotificationNotifierState({
    @Default([]) List<StageNotification> viewedNotifications,
    @Default([]) List<StageNotification> newNotifications,
    @Default(false) bool hasNewNotifications,
    @Default(false) bool hasMoreViewedNotifications,
    @Default(false) bool hasMoreNewNotifications,
  }) = _NotificationNotifierState;
}
