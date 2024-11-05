import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_section.dart';

class NotificationList extends ConsumerWidget {
  const NotificationList({
    required this.notifications,
    super.key,
  });

  final List<StageNotification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          NotificationSection(
            isUnread: true,
            notifications: newNotifications,
          ),
        if (viewedNotifications.isNotEmpty)
          NotificationSection(
            isUnread: false,
            notifications: viewedNotifications,
          ),
      ],
    );
  }
}
