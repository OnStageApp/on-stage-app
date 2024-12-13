import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      margin: const EdgeInsets.only(right: 10),
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          overlayColor: context.colorScheme.surfaceBright,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: context.colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          context.pushNamed(AppRoute.editUserProfile.name);
        },
        child: Text(
          'Edit Profile',
          style: context.textTheme.titleMedium,
        ),
      ),
    );
  }
}
