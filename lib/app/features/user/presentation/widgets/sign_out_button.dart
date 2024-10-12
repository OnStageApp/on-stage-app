import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferencesActionTile(
      title: 'Sign Out',
      height: 54,
      leadingWidget: Icon(
        Icons.logout,
        color: context.colorScheme.error,
        size: 20,
      ),
      onTap: () async {
        await ref.read(loginNotifierProvider.notifier).signOut();
      },
    );
  }
}
