import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.title,
    required this.dateTime,
    required this.onTap,
    this.hasActions = false,
    this.seen = false,
    this.leftTime,
    super.key,
  });

  final String title;
  final DateTime? dateTime;
  final bool hasActions;
  final bool seen;
  final String? leftTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          backgroundColor: context.colorScheme.onSurfaceVariant,
          overlayColor: context.colorScheme.outline.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftTime ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.surfaceDim,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (seen) _buildCircle(context.colorScheme.error),
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
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                          ),
                          _buildCircle(
                            context.colorScheme.outline.withOpacity(0.2),
                          ),
                          Text(
                            dateTime != null
                                ? TimeUtils().formatOnlyDate(dateTime)
                                : '',
                            style: context.textTheme.bodyMedium!.copyWith(
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
        ),
      ),
    );
  }

  Widget _buildCircle(Color backgroundColor) {
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
