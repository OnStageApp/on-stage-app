import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class GroupTile extends ConsumerWidget {
  const GroupTile({
    required this.title,
    required this.hasUpcomingEvent,
    super.key,
  });

  final String title;
  final bool hasUpcomingEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(const Color(0x33FFFFFF)),
      onTap: () {
        context.pushNamed(
          AppRoute.teamDetails.name,
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Assets.icons.userFriends.svg(),
                ),
                const SizedBox(width: Insets.small),
                Expanded(
                  child: AutoSizeText(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    minFontSize: 10,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                if (hasUpcomingEvent)
                  ParticipantsOnTile(
                    borderColor: context.colorScheme.onSurfaceVariant,
                    backgroundColor: context.colorScheme.tertiary,
                    participantsLength: ref
                            .watch(teamNotifierProvider)
                            .currentTeam
                            ?.membersCount ??
                        0,
                    participantsProfileBytes: ref
                            .watch(teamNotifierProvider)
                            .currentTeam
                            ?.memberPhotos ??
                        [],
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
