import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    required this.title,
    required this.hasUpcomingEvent,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool hasUpcomingEvent;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: hasUpcomingEvent ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.userFriends.svg(),
                const SizedBox(width: Insets.small),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                if (hasUpcomingEvent)
                  const ParticipantsOnTile(
                    borderColor: Colors.transparent,
                    showOverlay: false,
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
                  )
                else
                  const Text('Invite friends'),
                const Expanded(child: SizedBox()),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F2EA),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Assets.icons.arrowForward.svg(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
