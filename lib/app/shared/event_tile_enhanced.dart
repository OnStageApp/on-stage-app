import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTileEnhanced extends StatelessWidget {
  const EventTileEnhanced({
    required this.title,
    required this.hour,
    required this.location,
    super.key,
  });

  final String title;
  final String hour;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ParticipantsOnTile(
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
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/pattern_1.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.surface,
                ),
            maxLines: 1,
          ),
          Row(
            children: [
              Text(
                hour,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
              _buildCircle(context),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 4,
        color: context.colorScheme.surface,
      ),
    );
  }
}
