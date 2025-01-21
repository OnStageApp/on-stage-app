import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class ActionNotificationTile extends NotificationTile {
  const ActionNotificationTile({
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notification.status == NotificationStatus.NEW)
                        _buildCircle(context.colorScheme.error),
                      Text(
                        notification.title ?? 'Notification',
                        style: context.textTheme.headlineMedium!
                            .copyWith(color: context.colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: InviteButton(
                    text: notification.actionStatus?.title ?? 'Declined',
                    isConfirm: notification.actionStatus ==
                        NotificationActionStatus.ACCEPTED,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Row _buildDateTime(BuildContext context) {
    return Row(
      children: [
        Text(
          TimeUtils().formatOnlyTime(
            (notification.params?.date ?? DateTime.now()).toLocal(),
          ),
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surfaceDim,
          ),
        ),
        _buildCircle(
          context.colorScheme.outline.withOpacity(0.2),
        ),
        Text(
          TimeUtils().formatOnlyDate(
            (notification.params?.date ?? DateTime.now()).toLocal(),
          ),
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surfaceDim,
          ),
        ),
      ],
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
