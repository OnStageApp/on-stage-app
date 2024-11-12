import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferencesActionTile(
      title: 'Delete Account',
      height: 54,
      leadingWidget: Icon(
        Icons.delete_outline,
        color: context.colorScheme.error,
        size: 20,
      ),
      color: context.colorScheme.error,
      onTap: () {
        _onTap(context, ref);
      },
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
                  context.popDialog();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteAccount(ref);
                  context.popDialog();
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
                  context.popDialog();
                },
              ),
              CupertinoDialogAction(
                onPressed: () {
                  _deleteAccount(ref);
                  context.popDialog();
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

  Future<void> _deleteAccount(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).deleteAccount();
  }
}
