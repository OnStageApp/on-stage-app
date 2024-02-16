import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.date,
    required this.time,
    required this.onTap,
    super.key,
  });

  final String title;
  final String date;

  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      _buildCircle(context),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodyMedium,
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
        color: context.colorScheme.outline,
      ),
    );
  }
}
