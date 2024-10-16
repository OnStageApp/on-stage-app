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
    super.key,
  });

  final Widget? leadingWidget;
  final String title;
  final Color? color;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final double? height;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
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
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  trailingIcon,
                  size: 24,
                  color: const Color(0xFF828282),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
