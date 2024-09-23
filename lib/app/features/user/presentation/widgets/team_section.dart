import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/create_new_team_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/switch_teams_button.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class TeamsSection extends ConsumerWidget {
  const TeamsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTeam = ref.watch(teamNotifierProvider).currentTeam;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SwitchTeamsButton(),
        const SizedBox(height: 12),
        if (currentTeam != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              splashColor: context.colorScheme.surfaceBright,
              tileColor: context.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              title: Text(
                currentTeam.name ?? '',
                style: context.textTheme.headlineMedium,
              ),
              subtitle: Text(
                (currentTeam.membersCount ?? 0) > 1
                    ? '${currentTeam.membersCount} Members'
                    : '${currentTeam.membersCount} Member',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
              trailing: ParticipantsOnTile(
                participantsProfileBytes: currentTeam.memberPhotos,
                participantsLength: currentTeam.membersCount,
              ),
              onTap: () {
                context.pushNamed(
                  AppRoute.teamDetails.name,
                  extra: currentTeam,
                );
              },
            ),
          )
        else
          //shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        CreateNewTeamButton(
          icon: Icons.group,
          title: 'Create New Team',
          actionTitle: 'Create',
          onTap: () {
            context.goNamed(
              AppRoute.teamDetails.name,
              queryParameters: {'isCreating': 'true'},
            );
          },
        ),
      ],
    );
  }
}
