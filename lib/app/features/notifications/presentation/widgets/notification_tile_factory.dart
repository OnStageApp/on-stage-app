// notification_tile_factory.dart
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_actions.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/action_notification_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/photo_message_notification_tile.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';

class NotificationTileFactory extends ConsumerWidget {
  const NotificationTileFactory({
    required this.notification,
    super.key,
  });

  final StageNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationActions = ref.read(notificationActionsProvider);

    switch (notification.type) {
      case NotificationType.TEAM_INVITATION_REQUEST:
        return ActionNotificationTile(
          notification: notification,
          onTap: () {},
          onConfirm: () {
            notificationActions.updateTeamInvitation(
              notification,
              hasAccepted: true,
            );
          },
          onDecline: () {
            notificationActions.updateTeamInvitation(
              notification,
              hasAccepted: false,
            );
          },
        );
      case NotificationType.EVENT_INVITATION_REQUEST:
        return ActionNotificationTile(
          notification: notification,
          onTap: () {
            if (notification.actionStatus ==
                NotificationActionStatus.ACCEPTED) {
              notificationActions.goToEvent(
                notification.params?.eventId,
                context,
              );
            }
          },
          onConfirm: () {
            notificationActions.handleEventInvitation(
              notification,
              StagerStatusEnum.CONFIRMED,
              NotificationActionStatus.ACCEPTED,
            );
          },
          onDecline: () {
            notificationActions.handleEventInvitation(
              notification,
              StagerStatusEnum.DECLINED,
              NotificationActionStatus.DECLINED,
            );
          },
        );
      case NotificationType.EVENT_INVITATION_ACCEPTED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          onTap: () {
            notificationActions.goToEvent(
              notification.params?.eventId,
              context,
            );
          },
        );
      case NotificationType.EVENT_INVITATION_DECLINED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          onTap: () {
            notificationActions.goToEvent(
              notification.params?.eventId,
              context,
            );
          },
        );
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          onTap: () {},
        );
      case NotificationType.TEAM_INVITATION_DECLINED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          onTap: () {},
        );
      case NotificationType.NEW_REHEARSAL:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          icon: LucideIcons.repeat_2,
          onTap: () {
            notificationActions.goToEvent(
              notification.params?.eventId,
              context,
            );
          },
        );
      case NotificationType.LEAD_VOICE_ASSIGNED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          icon: LucideIcons.mic,
          onTap: () {
            notificationActions.goToEvent(
              notification.params?.eventId,
              context,
            );
          },
        );

      case NotificationType.EVENT_DELETED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          icon: LucideIcons.trash,
          onTap: () {},
        );
      case NotificationType.TEAM_MEMBER_REMOVED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          icon: LucideIcons.user_minus,
          onTap: () {},
        );
      case null:
        return const SizedBox();
    }
  }
}
