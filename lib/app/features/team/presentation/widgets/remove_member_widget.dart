import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
    if (Platform.isAndroid) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: _buildTitle(),
            content: _buildContent(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _removeMember(ref, context);
                },
                child: const Text('Remove'),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog<void>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: _buildTitle(),
            content: _buildContent(),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                onPressed: () {
                  _removeMember(ref, context);
                },
                isDestructiveAction: true,
                child: const Text('Remove'),
              ),
            ],
          );
        },
      );
    }
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

    context
      ..popDialog()
      ..popDialog();
  }
}
