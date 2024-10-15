import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/photo_message_notification_tile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({
    required this.notifications,
    super.key,
  });

  final List<StageNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final leftTime = _getLeftTime(notification.dateTime ?? DateTime.now());

        return PhotoMessageNotificationTile(
          title: notification.type?.title ?? '',
          description: notification.description,
          dateTime: notification.dateTime,
          hasActions: notification.isInvitationConfirmed ?? true,
          status: notification.status ?? NotificationStatus.NEW,
          onTap: () {},
        );
      },
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
