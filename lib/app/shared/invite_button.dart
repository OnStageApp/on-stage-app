import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    required this.text,
    required this.isConfirm,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    super.key,
  });

  static const _confirmColor = Color.fromARGB(255, 70, 209, 74);
  static const _cancelColor = Color.fromARGB(255, 227, 85, 77);

  final String text;
  final void Function()? onPressed;
  final bool isConfirm;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

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
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ??
              (isConfirm
                  ? _confirmColor.withAlpha(50)
                  : _cancelColor.withAlpha(50)),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return context.colorScheme.primary.withAlpha(25);
            }
            return null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? (isConfirm ? LucideIcons.circle_check : Icons.cancel),
            size: 20,
            color: textColor ?? (isConfirm ? _confirmColor : _cancelColor),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              color: textColor ?? (isConfirm ? _confirmColor : _cancelColor),
            ),
          ),
        ],
      ),
    );
  }
}
