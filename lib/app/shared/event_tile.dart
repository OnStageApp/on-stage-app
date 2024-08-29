import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.dateTime,
    required this.onTap,
    super.key,
  });

  final String title;
  final DateTime? dateTime;

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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        TimeUtils().formatOnlyTime(dateTime),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                      ),
                      _buildCircle(context),
                      Text(
                        dateTime != null
                            ? TimeUtils().formatOnlyDate(dateTime)
                            : '',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
