import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/presentation/widgets/create_new_team_modal.dart';
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
            title: (currentTeam != null)
                ? Text(
                    currentTeam.name,
                    style: context.textTheme.headlineMedium,
                  )
                : //shimmer
                _buildShimmer(context, height: 18, width: 200),
            subtitle: (currentTeam != null)
                ? Text(
                    (currentTeam.membersCount ?? 0) > 1
                        ? '${currentTeam.membersCount} Members'
                        : '${currentTeam.membersCount} Member',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  )
                : _buildShimmer(context, height: 14),
            trailing: (currentTeam != null)
                ? ParticipantsOnTile(
                    participantsProfileBytes: currentTeam.memberPhotos,
                    participantsLength: currentTeam.membersCount,
                  )
                : const SizedBox(),
            onTap: () {
              context.pushNamed(
                AppRoute.teamDetails.name,
                extra: currentTeam,
              );
            },
          ),
        ),
        CreateNewTeamButton(
          icon: Icons.group,
          title: 'Create New Team',
          actionTitle: 'Create',
          onTap: () {
            CreateNewTeamModal.show(context: context);
          },
        ),
      ],
    );
  }

  Widget _buildShimmer(
    BuildContext context, {
    double height = 12,
    double width = 100,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: context.colorScheme.surface.withOpacity(0.4),
        highlightColor: context.colorScheme.surface,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
