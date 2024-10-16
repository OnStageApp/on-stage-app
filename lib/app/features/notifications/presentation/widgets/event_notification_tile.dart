import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventNotificationTile extends NotificationTile {
  const EventNotificationTile({
    required super.title,
    required super.onTap,
    super.description,
    this.dateTime,
    super.status,
    this.hasActions = true,
    this.profilePicture,
    super.key,
  });

  final DateTime? dateTime;
  final bool hasActions;
  final Uint8List? profilePicture;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duminica seara',
                    style: context.textTheme.headlineMedium!
                        .copyWith(color: context.colorScheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildDateTime(context),
                ],
              ),
            ),
            const ParticipantsOnTile(
              participantsLength: 3,
            ),
          ],
        ),
        if (hasActions)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child: InviteButton(
                    text: 'Decline',
                    onPressed: () {},
                    isConfirm: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InviteButton(
                    text: 'Confirm',
                    onPressed: () {},
                    isConfirm: true,
                  ),
                ),
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
          TimeUtils().formatOnlyTime(dateTime ?? DateTime.now()),
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surfaceDim,
          ),
        ),
        _buildCircle(
          context.colorScheme.outline.withOpacity(0.2),
        ),
        Text(
          TimeUtils().formatOnlyDate(
            dateTime ?? DateTime.now(),
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
        size: 8,
        color: backgroundColor,
      ),
    );
  }
}
