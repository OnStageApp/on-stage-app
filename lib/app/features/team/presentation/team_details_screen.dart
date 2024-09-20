import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/features/team/presentation/team_member_modal.dart';
import 'package:on_stage_app/app/features/team/presentation/team_members_modal.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/member_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamDetailsScreen extends ConsumerStatefulWidget {
  const TeamDetailsScreen({
    this.isCreating = false,
    this.team,
    super.key,
  });

  final bool isCreating;
  final Team? team;

  @override
  TeamDetailsScreenState createState() => TeamDetailsScreenState();
}

class TeamDetailsScreenState extends ConsumerState<TeamDetailsScreen> {
  final teamNameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isCreating) {
        ref.read(teamMembersNotifierProvider.notifier).getTeamMembers();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
        title: widget.isCreating ? 'Create New Team' : 'Team Details',
        isBackButtonVisible: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CustomSettingTile(
              backgroundColor: context.colorScheme.onSurfaceVariant,
              placeholder: widget.team?.name ?? 'Enter Team Name',
              headline: 'Team Name',
              suffix: const SizedBox(),
              onTap: () {},
              controller: widget.isCreating ? teamNameController : null,
            ),
            const SizedBox(height: 16),
            Text('Members', style: context.textTheme.titleSmall),
            _buildParticipantsList(),
            const SizedBox(height: 12),
            EventActionButton(
              onTap: () {
                TeamMembersModal.show(teamId: '1', context: context);
              },
              text: 'Invite People',
              icon: Icons.add,
            ),
            if (widget.isCreating) ...[
              const Spacer(),
              ContinueButton(
                text: 'Create',
                onPressed: () {
                  ref.read(teamNotifierProvider.notifier).createTeam(
                        TeamRequest(name: teamNameController.text),
                      );
                  context.pop();
                },
                isEnabled: true,
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    final teamMembers = ref.watch(teamMembersNotifierProvider).teamMembers;
    if (teamMembers.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MemberTileWidget(
              name: teamMembers.elementAt(index).name ?? 'Name',
              photo: teamMembers[index].profilePicture,
              trailing: teamMembers.elementAt(index).role?.name ?? 'Role',
              onTap: () {
                TeamMemberModal.show(
                  onSave: (model) {},
                  context: context,
                  teamMember: teamMembers[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
