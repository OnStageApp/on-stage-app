import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CreateNewTeamButton extends StatelessWidget {
  const CreateNewTeamButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: context.colorScheme.surfaceBright,
      tileColor: context.colorScheme.onSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(
        Icons.group,
        color: context.colorScheme.outline,
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      title: Text(
        'Create New Team',
        style: context.textTheme.titleMedium,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Upgrade',
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.outline),
        ),
      ),
      onTap: () {
        context.goNamed(
          AppRoute.teamDetails.name,
          queryParameters: {'isCreating': 'true'},
        );
      },
    );
  }
}
