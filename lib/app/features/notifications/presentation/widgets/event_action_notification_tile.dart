import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventActionNotificationTile extends NotificationTile {
  const EventActionNotificationTile({
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
  Widget buildContent(BuildContext context, WidgetRef ref) {
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
                      ? context.colorScheme.surfaceContainerHigh.withAlpha(110)
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
        if (notification.actionStatus != NotificationActionStatus.DISABLED)
          _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Padding(
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
          ] else
            Expanded(
              child: InviteButton(
                icon: _isAccepted()
                    ? LucideIcons.calendar_check_2
                    : LucideIcons.calendar_x_2,
                onPressed: _isAccepted()
                    ? () {
                        final eventId = notification.params?.eventId;
                        context.goNamed(
                          AppRoute.eventDetails.name,
                          queryParameters: {'eventId': eventId},
                        );
                      }
                    : null,
                text: _isAccepted() ? 'Go to Event' : 'Declined',
                isConfirm: _isAccepted(),
              ),
            ),
        ],
      ),
    );
  }

  bool _isAccepted() {
    return notification.actionStatus == NotificationActionStatus.ACCEPTED;
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
          context.colorScheme.outline.withAlpha(10),
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
      padding: const EdgeInsets.only(right: 4),
      child: Icon(
        Icons.circle,
        size: 12,
        color: backgroundColor,
      ),
    );
  }
}
