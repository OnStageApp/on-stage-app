import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_filter.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
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

  Future<NotificationPagination> _getNotifications({
    NotificationStatus? status,
  }) async {
    try {
      final userId = ref.read(userNotifierProvider).currentUser?.id;
      if (userId == null) return const NotificationPagination();

      return notificationRepository
          .getNotifications(NotificationFilter(status: status));
    } catch (e, s) {
      logger.e('Error getting notifications: $e $s');
      return const NotificationPagination();
    }
  }

  Future<void> getViewedNotifications() async {
    final viewedNotifications =
        await _getNotifications(status: NotificationStatus.VIEWED);
    state = state.copyWith(
      viewedNotifications: viewedNotifications.notifications,
      hasMoreViewedNotifications: viewedNotifications.hasMore ?? false,
    );
  }

  Future<void> getNewNotifications() async {
    final newNotifications = await _getNotifications(
      status: NotificationStatus.NEW,
    );

    state = state.copyWith(
      newNotifications: newNotifications.notifications,
      hasMoreNewNotifications: newNotifications.hasMore ?? false,
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
      final updatedNotification = StageNotification(
        notificationId: notificationId,
        status: status,
        actionStatus: actionStatus,
      );
      _updateNotificationLocally(status, notificationId, updatedNotification);
      await notificationRepository.updateNotification(
        notificationId,
        updatedNotification,
      );
    } catch (e, s) {
      logger.e('Error updating notification: $e $s');
    }
  }

  void _updateNotificationLocally(
    NotificationStatus status,
    String notificationId,
    StageNotification updatedNotification,
  ) {
    if (status == NotificationStatus.VIEWED) {
      state = state.copyWith(
        viewedNotifications: state.viewedNotifications
            .map(
              (n) =>
                  n.notificationId == notificationId ? updatedNotification : n,
            )
            .toList(),
      );
    } else {
      state = state.copyWith(
        newNotifications: state.newNotifications
            .map(
              (n) =>
                  n.notificationId == notificationId ? updatedNotification : n,
            )
            .toList(),
      );
    }
  }

  void setHasNewNotifications(bool hasNewNotifications) {
    state = state.copyWith(hasNewNotifications: hasNewNotifications);
  }
}
