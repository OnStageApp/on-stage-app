import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CreateNewTeamButton extends StatelessWidget {
  const CreateNewTeamButton({
    required this.icon,
    required this.title,
    required this.actionTitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String actionTitle;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: context.colorScheme.surfaceBright,
      tileColor: context.colorScheme.onSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(
        icon,
        color: context.colorScheme.outline,
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      title: Text(
        title,
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
          actionTitle,
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.outline),
        ),
      ),
      onTap: onTap,
    );
  }
}
