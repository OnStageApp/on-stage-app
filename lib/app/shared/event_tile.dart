import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.dateTime,
    required this.onTap,
    this.isNotification = false,
    this.isNotificationHasActionButtons = false,
    this.isNotificationNew = false,
    this.leftTime,
    super.key,
  });

  final String title;
  final DateTime dateTime;
  final bool isNotification;
  final bool isNotificationHasActionButtons;
  final bool isNotificationNew;
  final String? leftTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNotification) ...[
              Text(
                leftTime ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.surfaceDim,
                ),
              ),
              const SizedBox(height: 3),
            ],
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isNotificationNew)
                            _buildCircle(context, context.colorScheme.error),
                          Text(
                            title,
                            style: context.textTheme.headlineMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            TimeUtils().formatOnlyTime(dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                          ),
                          _buildCircle(context, context.colorScheme.outline.withOpacity(0.2)),
                          Text(
                            TimeUtils().formatOnlyDate(dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const ParticipantsOnTile(
                  borderColor: Colors.transparent,
                  participantsProfile: [
                    'assets/images/profile1.png',
                    'assets/images/profile2.png',
                    'assets/images/profile4.png',
                    'assets/images/profile5.png',
                    'assets/images/profile5.png',
                    'assets/images/profile5.png',
                    'assets/images/profile5.png',
                    'assets/images/profile5.png',
                  ],
                ),
              ],
            ),
            if (isNotificationHasActionButtons)
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
              )
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(BuildContext context, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: backgroundColor,
      ),
    );
  }

}
