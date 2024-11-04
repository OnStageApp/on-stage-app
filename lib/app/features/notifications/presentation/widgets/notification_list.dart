import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/action_notification_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/photo_message_notification_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

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
          _buildNotificationSection(
            context,
            ref,
            isUnread: true,
            notifications: newNotifications,
          ),
        if (viewedNotifications.isNotEmpty)
          _buildNotificationSection(
            context,
            ref,
            isUnread: false,
            notifications: viewedNotifications,
          ),
      ],
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    WidgetRef ref, {
    required bool isUnread,
    required List<StageNotification> notifications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isUnread)
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
                isUnread ? 'Unread' : 'Older',
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

            switch (notification.type) {
              case NotificationType.TEAM_INVITATION_REQUEST:
                return PhotoMessageNotificationTile(
                  notification: notification,
                  onTap: () {},
                );
              case NotificationType.EVENT_INVITATION_REQUEST:
                return ActionNotificationTile(
                  notification: notification,
                  onTap: () {
                    if (notification.actionStatus ==
                        NotificationActionStatus.ACCEPTED) {
                      _goToEvent(notification, ref, context);
                    }
                  },
                  onConfirm: () {
                    onTapAction(
                      notification,
                      StagerStatusEnum.CONFIRMED,
                      NotificationActionStatus.ACCEPTED,
                      ref,
                    );
                  },
                  onDecline: () {
                    onTapAction(
                      notification,
                      StagerStatusEnum.DECLINED,
                      NotificationActionStatus.DECLINED,
                      ref,
                    );
                  },
                );
              case NotificationType.TEAM_INVITATION_ACCEPTED:
                return PhotoMessageNotificationTile(
                  notification: notification,
                  onTap: () {},
                );
              case NotificationType.NEW_REHEARSAL:
                return PhotoMessageNotificationTile(
                  notification: notification,
                  onTap: () {
                    _goToEvent(notification, ref, context);
                  },
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  void _goToEvent(
    StageNotification notification,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (notification.eventId != null) {
      ref
          .read(eventNotifierProvider.notifier)
          .getEventById(notification.eventId!);
      context.goNamed(
        AppRoute.eventDetails.name,
        queryParameters: {
          'eventId': notification.eventId,
        },
      );
    } else {
      logger.i('Event id is null');
    }
  }

  void onTapAction(
    StageNotification notification,
    StagerStatusEnum status,
    NotificationActionStatus actionStatus,
    WidgetRef ref,
  ) {
    ref.read(eventNotifierProvider.notifier).setStatusForStager(
          participationStatus: status,
          eventId: notification.eventId ?? '',
        );

    ref.read(notificationNotifierProvider.notifier).updateNotification(
          notification.notificationId,
          actionStatus,
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
