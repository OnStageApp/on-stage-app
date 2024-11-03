import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  NotificationRepository? _notificationRepository;

  NotificationRepository get notificationRepository {
    _notificationRepository ??= NotificationRepository(ref.read(dioProvider));
    return _notificationRepository!;
  }

  @override
  NotificationNotifierState build() {
    logger.i('NotificationNotifier building');
    return const NotificationNotifierState();
  }

  Future<void> getNotifications() async {
    try {
      final userId = ref.read(userNotifierProvider).currentUser?.id;
      if (userId == null) return;

      final notifications =
          await notificationRepository.getNotifications(userId);

      state = state.copyWith(notifications: notifications);
    } catch (e, s) {
      logger.e('Error getting notifications: $e $s');
    }
  }

  Future<void> markNotificationsAsViewed() async {
    try {
      state = state.copyWith(
        notifications: state.notifications
            .map(
              (notification) =>
                  notification.copyWith(status: NotificationStatus.VIEWED),
            )
            .toList(),
      );
      await notificationRepository.markAsViewed();
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  Future<void> updateNotification(
    String notificationId,
    NotificationActionStatus actionStatus,
  ) async {
    try {
      final notification = state.notifications.firstWhere(
        (notification) => notification.notificationId == notificationId,
      );
      final updatedNotification = notification.copyWith(
        actionStatus: actionStatus,
      );
      final updatedNotifications = state.notifications.map((n) {
        if (n.notificationId == notificationId) {
          return updatedNotification;
        }
        return n;
      }).toList();
      state = state.copyWith(notifications: updatedNotifications);

      await notificationRepository.updateNotification(
        notificationId,
        updatedNotification,
      );
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  void setHasNewNotifications(bool hasNewNotifications) {
    state = state.copyWith(hasNewNotifications: hasNewNotifications);
  }
}
