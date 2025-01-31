import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/team/presentation/widgets/change_permissions_modal.dart';
import 'package:on_stage_app/app/features/team/presentation/widgets/remove_member_widget.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamMemberModal extends ConsumerStatefulWidget {
  const TeamMemberModal({
    required this.teamMember,
    this.onSave,
    super.key,
  });

  final void Function(RehearsalModel)? onSave;
  final TeamMember teamMember;

  @override
  TeamMemberModalState createState() => TeamMemberModalState();

  static void show({
    required BuildContext context,
    required TeamMember teamMember,
    void Function(RehearsalModel)? onSave,
  }) {
    AdaptiveModal.show(
      context: context,
      expand: false,
      child: TeamMemberModal(
        onSave: onSave,
        teamMember: teamMember,
      ),
    );
  }
}

class TeamMemberModalState extends ConsumerState<TeamMemberModal> {
  late TeamMember teamMember;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    teamMember = widget.teamMember;
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> handlePermissionChange() async {
    final role = await ChangePermissionsModal.show(
      context: context,
      selectedRole: teamMember.role ?? TeamMemberRole.none,
    );

    if (role != null && mounted) {
      setState(() => teamMember = teamMember.copyWith(role: role));

      await ref.read(teamMembersNotifierProvider.notifier).updateTeamMemberRole(
            teamMember.id,
            role,
          );

      await ref.read(teamMembersNotifierProvider.notifier).getTeamMembers();

      if (mounted) {
        context.popDialog();
        TopFlushBar.show(
          context,
          'Permissions have been updated',
        );
      }
    }
  }

  Future<void> handleResendInvitation() async {
    if (!mounted) return;

    await ref
        .read(teamMembersNotifierProvider.notifier)
        .resendInvitationOnTeamMember(
          teamMember.id ?? '',
          teamMember.role ?? TeamMemberRole.none,
        );

    if (mounted) {
      context.popDialog();
      TopFlushBar.show(
        context,
        'Invitation has been resent',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Team Member'),
        headerHeight: () => 64,
        buildContent: () => SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding,
            child: Column(
              children: [
                _buildContent(
                  teamMember.profilePicture,
                  teamMember.name ?? 'Name',
                  '',
                  () {
                    context
                      ..popDialog()
                      ..pushNamed(
                        AppRoute.userProfileInfo.name,
                        queryParameters: {
                          'userId': teamMember.userId,
                        },
                      );
                  },
                ),
                const SizedBox(height: 12),
                _buildContent(
                  null,
                  'Change permissions',
                  teamMember.role?.title ?? 'None',
                  handlePermissionChange,
                ),
                const SizedBox(height: 64),
                if (teamMember.inviteStatus == InviteStatus.pending)
                  _buildResendInvitation(context),
                const SizedBox(height: 12),
                RemoveMemberWidget(
                  teamMemberId: teamMember.id,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendInvitation(BuildContext context) {
    return InkWell(
      onTap: handleResendInvitation,
      overlayColor: WidgetStateProperty.all(
        context.colorScheme.outline.withOpacity(0.1),
      ),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Resend invitation',
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    Uint8List? photo,
    String? name,
    String trailing,
    void Function() onTap,
  ) =>
      InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        overlayColor: WidgetStateProperty.all(
          context.colorScheme.outline.withOpacity(0.1),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (photo != null) ...[
                ImageWithPlaceholder(
                  photo: photo,
                  name: name!,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                name ?? 'Unknown',
                style: context.textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                trailing,
                style: context.textTheme.titleMedium!
                    .copyWith(color: context.colorScheme.outline),
              ),
            ],
          ),
        ),
      );
}
