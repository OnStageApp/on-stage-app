import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_section.dart';

class NotificationList extends ConsumerWidget {
  const NotificationList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newNotifications =
        ref.watch(notificationNotifierProvider).newNotifications;

    final viewedNotifications =
        ref.watch(notificationNotifierProvider).viewedNotifications;

    if (newNotifications.isEmpty && viewedNotifications.isEmpty) {
      return const Center(child: Text('No notifications'));
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
