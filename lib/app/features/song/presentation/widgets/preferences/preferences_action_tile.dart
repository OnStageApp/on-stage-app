import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferencesActionTile extends StatelessWidget {
  const PreferencesActionTile({
    required this.title,
    required this.onTap,
    this.leadingWidget,
    this.trailingIcon,
    this.color,
    this.height,
    this.suffixWidget,
    this.backgroundColor,
    super.key,
  });

  final Widget? leadingWidget;
  final String title;
  final Color? color;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final double? height;
  final Widget? suffixWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      borderRadius: BorderRadius.circular(8),
      overlayColor: WidgetStateProperty.all(context.colorScheme.surfaceBright),
      child: Ink(
        height: height ?? 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (leadingWidget != null) ...[
              leadingWidget!,
              const SizedBox(width: Insets.smallNormal),
            ],
            Text(
              title,
              style: context.textTheme.titleMedium!.copyWith(
                color: color ?? context.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (suffixWidget != null) suffixWidget!,
            if (trailingIcon != null)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? const Color(0xFF43474E)
                      : context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  trailingIcon,
                  size: 24,
                  color: const Color(0xFF8E9199),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
