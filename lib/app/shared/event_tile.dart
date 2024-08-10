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
    this.isNotification,
    this.isInvitationConfirmed,
    this.leftTime,
    super.key,
  });

  final String title;
  final DateTime dateTime;
  final bool? isNotification;
  final bool? isInvitationConfirmed;
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
            if (isNotification != false)
              Column(
                children: [
                  Text(
                    '$leftTime',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.surfaceDim,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 1,
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
                          _buildCircle(context),
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
                _buildParticipantsTile(),
                const Divider(),
              ],
            ),
            if (isInvitationConfirmed != false)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTile() {
    return const ParticipantsOnTile(
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
    );
  }

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: context.colorScheme.outline.withOpacity(0.2),
      ),
    );
  }
}
