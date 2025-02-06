import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_state.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class RemoveMemberWidget extends ConsumerWidget {
  const RemoveMemberWidget({
    required this.teamMemberId,
    super.key,
  });

  final String teamMemberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _setupErrorListener(ref, context);

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
    AdaptiveDialog.show(
      context: context,
      title: 'Remove Member',
      description: 'Are you sure you want to remove this member? '
          '\nThis action cannot be undone.',
      actionText: 'Remove',
      onAction: () => _removeMember(ref, context),
    );
  }

  Future<void> _removeMember(WidgetRef ref, BuildContext context) async {
    final success = await ref
        .read(teamMembersNotifierProvider.notifier)
        .removeTeamMember(teamMemberId);

    if (success) {
      unawaited(ref.read(teamNotifierProvider.notifier).getCurrentTeam());
      if (context.mounted) {
        context.popDialog();
      }
    }
  }

  void _setupErrorListener(WidgetRef ref, BuildContext context) {
    ref.listen<TeamMembersState>(
      teamMembersNotifierProvider,
      (previous, next) {
        if (next.error != null && context.mounted) {
          TopFlushBar.show(
            context,
            next.error.toString(),
            isError: true,
          );
        }
      },
    );
  }
}
