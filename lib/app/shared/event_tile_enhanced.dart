import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTileEnhanced extends StatelessWidget {
  const EventTileEnhanced({
    required this.title,
    required this.hour,
    required this.date,
    this.locationName,
    this.isSingleEvent = false,
    super.key,
  });

  final String title;
  final String hour;
  final String date;
  final bool isSingleEvent;
  final String? locationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: isSingleEvent ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSingleEvent) _buildDateTimeOnSingleEventShown(context),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          if (isSingleEvent)
            Text(
              locationName ?? '',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
            )
          else
            _buildDateTime(context),
          const SizedBox(height: 8),
          const Expanded(
            child: SizedBox(),
          ),
          const ParticipantsOnTile(
            backgroundColor: Colors.white,
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
    );
  }

  Widget _buildDateTimeOnSingleEventShown(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hour,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
          ),
          _buildCircle(context),
          Text(
            date,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTime(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isSingleEvent ? 8 : 0),
      padding: isSingleEvent
          ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
          : EdgeInsets.zero,
      decoration: isSingleEvent
          ? BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hour,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
          ),
          _buildCircle(context),
          Text(
            date,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 5,
        color: Color(0xFF009CC7),
      ),
    );
  }
}
