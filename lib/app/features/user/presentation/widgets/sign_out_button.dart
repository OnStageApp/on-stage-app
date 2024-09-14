import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
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
      onTap: () {
        context.goNamed(AppRoute.login.name);
      },
    );
  }
}
