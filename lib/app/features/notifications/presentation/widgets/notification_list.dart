import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile_factory.dart';

class NotificationList extends ConsumerWidget {
  const NotificationList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationNotifierProvider).notifications;

    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications'));
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        if (notifications.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationTileFactory(notification: notification);
                },
              ),
            ],
          ),
      ],
    );
  }
}
