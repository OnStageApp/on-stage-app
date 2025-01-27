import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventActionButton extends StatelessWidget {
  const EventActionButton({
    required this.onTap,
    required this.text,
    super.key,
    this.icon,
    this.padding,
    this.textColor,
  });

  final void Function() onTap;
  final String text;
  final IconData? icon;
  final Color? textColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(12),
        backgroundColor: context.colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: context.colorScheme.outline.withOpacity(0.1),
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
    );
  }
}
