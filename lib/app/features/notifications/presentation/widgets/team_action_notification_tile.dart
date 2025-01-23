import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_switch_team_button.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class TeamActionNotificationTile extends NotificationTile {
  const TeamActionNotificationTile({
    required super.onTap,
    required this.notification,
    this.onDecline,
    this.onConfirm,
    super.key,
  });

  final void Function()? onDecline;
  final void Function()? onConfirm;
  final StageNotification notification;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (notification.status == NotificationStatus.NEW)
                        _buildCircle(context.colorScheme.error),
                      Expanded(
                        child: Text(
                          notification.title ?? 'Notification',
                          style: context.textTheme.headlineMedium!
                              .copyWith(color: context.colorScheme.onSurface),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildDateTime(context),
                ],
              ),
            ),
            if (notification.params != null &&
                notification.params!.positionName.isNotNullEmptyOrWhitespace)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? context.colorScheme.surfaceContainerHigh
                          .withOpacity(0.5)
                      : context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  notification.params?.positionName ?? '',
                  style: context.textTheme.titleSmall,
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              if (notification.actionStatus ==
                  NotificationActionStatus.PENDING) ...[
                Expanded(
                  child: InviteButton(
                    text: 'Decline',
                    onPressed: onDecline ?? () {},
                    isConfirm: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InviteButton(
                    text: 'Confirm',
                    onPressed: onConfirm ?? () {},
                    isConfirm: true,
                  ),
                ),
              ] else ...[
                if (notification.actionStatus ==
                    NotificationActionStatus.DECLINED)
                  const Expanded(
                    child: InviteButton(
                      text: 'Declined',
                      isConfirm: false,
                    ),
                  )
                else
                  Expanded(
                    child: NotificationSwitchTeamButton(
                      text: 'Switch Team ',
                      teamId: notification.params?.teamId,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTime(BuildContext context) {
    return Text(
      'You have been invited to join ${notification.title ?? ''} team',
      style: context.textTheme.bodyMedium!.copyWith(
        color: context.colorScheme.surfaceDim,
      ),
    );
  }

  Widget _buildCircle(Color backgroundColor) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 12,
        color: backgroundColor,
      ),
    );
  }
}
