import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTileEnhanced extends StatelessWidget {
  const EventTileEnhanced({
    required this.title,
    required this.hour,
    required this.date,
    super.key,
  });

  final String title;
  final String hour;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Row(
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
          const SizedBox(height: 4),
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
