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
      tileColor: context.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.primaryContainer,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(
        icon,
        color: context.isDarkMode
            ? context.colorScheme.onSurface
            : context.colorScheme.outline,
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Icon(
          Icons.keyboard_arrow_right_rounded,
          size: 24,
          color: Color(0xFF828282),
        ),
      ),
      onTap: onTap,
    );
  }
}
