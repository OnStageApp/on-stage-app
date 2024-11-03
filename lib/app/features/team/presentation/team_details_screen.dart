import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/features/team/presentation/team_member_modal.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/router/app_router.dart';
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
            if (ref.watch(permissionServiceProvider).hasAccessToEdit) ...[
              const SizedBox(height: 12),
              EventActionButton(
                onTap: () {
                  ref.read(permissionServiceProvider).callMethodIfHasPermission(
                        context: context,
                        permissionType: PermissionType.addTeamMembers,
                        onGranted: () {
                          context.pushNamed(AppRoute.addTeamMember.name);
                        },
                      );
                },
                text: 'Invite People',
                icon: Icons.add,
              ),
            ],
            if (widget.isCreating) ...[
              const Spacer(),
              ContinueButton(
                text: 'Create',
                onPressed: () {
                  ref.read(teamNotifierProvider.notifier).createTeam(
                        TeamRequest(
                          name: teamNameController.text,
                          membersCount: 1,
                        ),
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
              name: teamMembers[index].name ?? 'Name',
              photo: teamMembers[index].profilePicture,
              trailing: _getTrailingText(teamMembers[index], index),
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

  String _getTrailingText(TeamMember member, int index) {
    if (member.inviteStatus == InviteStatus.pending) {
      return member.inviteStatus!.name;
    }
    return member.role?.name ?? 'Role';
  }
}
