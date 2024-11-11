import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventActionButton extends StatelessWidget {
  const EventActionButton({
    required this.onTap,
    required this.text,
    super.key,
    this.icon,
    this.textColor,
  });

  final void Function() onTap;
  final String text;
  final IconData? icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStateProperty.all(
        context.colorScheme.outline.withOpacity(0.1),
      ),
      child: Ink(
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
                color: textColor ?? context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
