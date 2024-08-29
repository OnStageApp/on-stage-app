import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class UpcomingEventTile extends StatelessWidget {
  const UpcomingEventTile({
    required this.title,
    required this.dateTime,
    required this.location,
    super.key,
  });

  final String title;
  final DateTime dateTime;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.surface,
                ),
            maxLines: 1,
          ),
          const SizedBox(height: 16),
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
          const Expanded(child: SizedBox()),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.surface,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: context.colorScheme.surface.withOpacity(0.6),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('HH:mm, dd MMM').format(dateTime),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: context.colorScheme.surface.withOpacity(0.6),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
