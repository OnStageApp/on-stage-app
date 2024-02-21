import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class UpcomingEventEnhanced extends StatelessWidget {
  const UpcomingEventEnhanced({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming', style: context.textTheme.bodySmall),
          const SizedBox(height: Insets.medium),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.surface,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Insets.medium),
          Row(
            children: [
              Text(
                hour,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
              _buildCircle(context),
              Text(
                "20 dec.",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
            ],
          ),
          Text(
            location,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.surface,
                ),
          ),
          const Expanded(child: SizedBox()),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ParticipantsOnTile(
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
              // Opacity(
              //   opacity: 0.5,
              //   child: Image.asset(
              //     'assets/images/pattern_1.png',
              //     height: 48,
              //     width: 48,
              //   ),
              // ),
            ],
          ),
          // const Expanded(
          //   child: SizedBox(),
          // ),
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
