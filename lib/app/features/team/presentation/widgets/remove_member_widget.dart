import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/dialog_helper.dart';

class RemoveMemberWidget extends ConsumerWidget {
  const RemoveMemberWidget({
    required this.teamMemberId,
    super.key,
  });

  final String teamMemberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        _onTap(context, ref);
      },
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
            'Remove member',
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.error),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    DialogHelper.showPlatformDialog(
      context: context,
      title: _buildTitle(),
      content: _buildContent(),
      confirmText: 'Remove',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: () => _removeMember(ref, context),
    );
  }

  Text _buildTitle() => const Text('Remove member');

  Text _buildContent() {
    return const Text(
      'Are you sure you want to remove this member? '
      'This action cannot be undone.',
    );
  }

  void _removeMember(WidgetRef ref, BuildContext context) {
    ref
        .read(teamMembersNotifierProvider.notifier)
        .removeTeamMember(teamMemberId);

    ref.read(teamNotifierProvider.notifier).getCurrentTeam();

    context.popDialog();
  }
}
