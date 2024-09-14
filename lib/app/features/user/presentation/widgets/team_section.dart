import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/create_new_team_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/switch_teams_button.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamsSection extends StatelessWidget {
  const TeamsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SwitchTeamsButton(),
        const SizedBox(height: 12),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Padding(
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
                  'Echipa Racheta',
                  style: context.textTheme.headlineMedium,
                ),
                subtitle: Text(
                  '4 Members',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                trailing: const ParticipantsOnTile(
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
                onTap: () {
                  context.pushNamed(AppRoute.teamDetails.name);
                },
              ),
            );
          },
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
