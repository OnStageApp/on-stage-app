import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_filter.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_pagination.dart';
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

  Future<NotificationPagination> _getNotifications() async {
    try {
      final userId = ref.read(userNotifierProvider).currentUser?.id;
      if (userId == null) return const NotificationPagination();

      return notificationRepository
          .getNotifications(const NotificationFilter());
    } catch (e, s) {
      logger.e('Error getting notifications: $e $s');
      return const NotificationPagination();
    }
  }

  Future<void> getNotifications() async {
    final newNotifications = await _getNotifications();

    state = state.copyWith(
      notifications: newNotifications.notifications,
      hasMoreNotifications: newNotifications.hasMore ?? false,
    );
  }

  Future<void> markNotificationsAsViewed() async {
    try {
      await notificationRepository.markAsViewed();
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  Future<void> updateNotification(
    String notificationId,
    NotificationStatus status,
    NotificationActionStatus actionStatus,
  ) async {
    try {
      state = state.copyWith(
        notifications: state.notifications.map((notification) {
          return notification.notificationId == notificationId
              ? notification.copyWith(
                  status: status, actionStatus: actionStatus)
              : notification;
        }).toList(),
      );

      await notificationRepository.updateNotification(
        notificationId,
        state.notifications.firstWhere(
          (notification) => notification.notificationId == notificationId,
        ),
      );
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  void setHasNewNotifications(bool hasNewNotifications) {
    state = state.copyWith(hasNewNotifications: hasNewNotifications);
  }
}
