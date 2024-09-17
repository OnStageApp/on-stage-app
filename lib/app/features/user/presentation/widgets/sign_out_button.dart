import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      splashColor: context.colorScheme.surfaceBright,
      tileColor: context.colorScheme.onSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Row(
        children: [
          Icon(
            Icons.logout,
            color: context.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Sign Out',
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
      onTap: () async {
        await ref.read(loginNotifierProvider.notifier).signOut();
      },
    );
  }
}
