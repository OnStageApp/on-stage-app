import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    required this.text,
    this.onPressed,
    required this.isConfirm,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String text;
  final void Function()? onPressed;
  final bool isConfirm;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ??
              (isConfirm
                  ? context.colorScheme.onSurface
                  : context.colorScheme.surface),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return context.colorScheme.primary.withOpacity(0.1);
            }
            return null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              color: textColor ??
                  (isConfirm
                      ? context.colorScheme.onSurfaceVariant
                      : context.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
