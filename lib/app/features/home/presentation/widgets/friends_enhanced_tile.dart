import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class FriendsEnhancedTile extends StatelessWidget {
  const FriendsEnhancedTile({
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
        color: context.colorScheme.onSecondary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Friends',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
              Text(
                "6",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: context.colorScheme.surface,
                    ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ParticipantsOnTile(
                width: 32,
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
              Container(
                alignment: Alignment.centerRight,
                width: 14,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 16,
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
