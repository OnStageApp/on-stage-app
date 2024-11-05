// notification_section.dart
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile_factory.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/section_header.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    required this.isUnread,
    required this.notifications,
    Key? key,
  }) : super(key: key);

  final bool isUnread;
  final List<StageNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(isUnread: isUnread),
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
    );
  }
}
