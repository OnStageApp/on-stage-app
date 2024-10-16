import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/event_notification_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/photo_message_notification_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({
    required this.notifications,
    super.key,
  });

  final List<StageNotification> notifications;

  @override
  Widget build(BuildContext context) {
    final newNotifications = notifications
        .where((notification) => notification.status == NotificationStatus.NEW)
        .toList();
    final viewedNotifications = notifications
        .where(
            (notification) => notification.status == NotificationStatus.VIEWED)
        .toList();

    if (newNotifications.isEmpty && viewedNotifications.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        if (newNotifications.isNotEmpty)
          _buildNotificationSection(
            context,
            title: 'Unread',
            notifications: newNotifications,
          ),
        if (viewedNotifications.isNotEmpty)
          _buildNotificationSection(
            context,
            title: 'Older',
            notifications: viewedNotifications,
          ),
      ],
    );
  }

  Widget _buildNotificationSection(
    BuildContext context, {
    required String title,
    required List<StageNotification> notifications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.circle,
                size: 12,
                color: context.colorScheme.error,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                style: context.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final leftTime =
                _getLeftTime(notification.dateTime ?? DateTime.now());

            switch (notification.type) {
              case NotificationType.TEAM_INVITATION_REQUEST:
                return PhotoMessageNotificationTile(
                  title: notification.type?.title ?? '',
                  description: notification.description,
                  dateTime: notification.dateTime,
                  hasActions: notification.isInvitationConfirmed ?? true,
                  status: notification.status ?? NotificationStatus.NEW,
                  onTap: () {},
                );
              case NotificationType.EVENT_INVITATION_REQUEST:
                return EventNotificationTile(
                  title: notification.type?.title ?? '',
                  description: notification.description,
                  dateTime: notification.dateTime,
                  hasActions: notification.isInvitationConfirmed ?? true,
                  status: notification.status ?? NotificationStatus.NEW,
                  onTap: () {},
                );
              case NotificationType.TEAM_INVITATION_ACCEPTED:
                return PhotoMessageNotificationTile(
                  title: notification.type?.title ?? '',
                  description: notification.description,
                  dateTime: notification.dateTime,
                  hasActions: false,
                  status: notification.status ?? NotificationStatus.NEW,
                  onTap: () {},
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  String _getLeftTime(DateTime dateTime) {
    final difference = dateTime.difference(DateTime.now()).inDays;

    if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1) {
      return 'Event in $difference days';
    } else {
      return 'Event today';
    }
  }
}
