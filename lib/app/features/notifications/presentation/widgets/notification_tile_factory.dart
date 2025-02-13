import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_actions.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/event_action_notification_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_icon_config.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/photo_message_notification_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/team_action_notification_tile.dart';
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
      case NotificationType.REMINDER:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.REMINDER,
            context,
          ),
          onTap: () {
            //TODO:  not possible yet
            // _goToEvent(notificationActions, context);
          },
        );
      case NotificationType.TEAM_INVITATION_REQUEST:
        return TeamActionNotificationTile(
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
        return EventActionNotificationTile(
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
          userId: notification.params?.userId,
          description: notification.description,
          onTap: () {
            _goToEvent(notificationActions, context);
          },
        );
      case NotificationType.EVENT_INVITATION_DECLINED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          onTap: () {},
        );
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        final userId = notification.params?.userId;

        return PhotoMessageNotificationTile(
          userId: userId,
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          onTap: () {},
        );
      case NotificationType.TEAM_INVITATION_DECLINED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          onTap: () {},
        );
      case NotificationType.NEW_REHEARSAL:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.NEW_REHEARSAL,
            context,
          ),
          onTap: () {
            if (notification.actionStatus !=
                NotificationActionStatus.DISABLED) {
              notificationActions.goToEvent(
                notification.params?.eventId,
                context,
              );
            }
          },
        );
      case NotificationType.LEAD_VOICE_ASSIGNED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          description: notification.description,
          userId: notification.params?.userId,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.LEAD_VOICE_ASSIGNED,
            context,
          ),
          onTap: () {
            if (notification.actionStatus !=
                NotificationActionStatus.DISABLED) {
              notificationActions.goToEvent(
                notification.params?.eventId,
                context,
              );
            }
          },
        );

      case NotificationType.EVENT_DELETED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.EVENT_DELETED,
            context,
          ),
          onTap: () {},
        );
      case NotificationType.TEAM_MEMBER_REMOVED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.TEAM_MEMBER_REMOVED,
            context,
          ),
          onTap: () {},
        );
      case NotificationType.LEAD_VOICE_REMOVED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.LEAD_VOICE_REMOVED,
            context,
          ),
          onTap: () {},
        );
      case NotificationType.ROLE_CHANGED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.ROLE_CHANGED,
            context,
          ),
          onTap: () {},
        );
      case NotificationType.TEAM_MEMBER_ADDED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.TEAM_MEMBER_ADDED,
            context,
          ),
          onTap: () {},
        );
      case NotificationType.STAGER_REMOVED:
        return PhotoMessageNotificationTile(
          status: notification.status ?? NotificationStatus.VIEWED,
          userId: notification.params?.userId,
          description: notification.description,
          iconConfig: NotificationIconHelper.getConfigForType(
            NotificationType.STAGER_REMOVED,
            context,
          ),
          onTap: () {},
        );
      case null:
        return const SizedBox();
    }
  }

  void _goToEvent(
    NotificationActions notificationActions,
    BuildContext context,
  ) {
    if (notification.actionStatus != NotificationActionStatus.DISABLED) {
      notificationActions.goToEvent(
        notification.params?.eventId,
        context,
      );
    }
  }
}
