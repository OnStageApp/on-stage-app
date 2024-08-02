import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class BlueActionButton extends StatelessWidget {
  const BlueActionButton({
    required this.onTap,
    required this.text,
    super.key,
    this.icon,
  });

  final void Function() onTap;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(width: 4),
            Text(
              text,
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
