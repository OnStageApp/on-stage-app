import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    required this.text,
    required this.onPressed,
    required this.isConfirm,
    this.hasShadow = true,
    super.key,
  });

  final String text;
  final void Function() onPressed;
  final bool isConfirm;

  final bool hasShadow;

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
        backgroundColor: WidgetStateProperty.all(
          isConfirm
              ? context.colorScheme.tertiary
              : context.colorScheme.surface,
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
          if (isConfirm != true)
            Assets.icons.close.svg()
          else
            Assets.icons.confirm.svg(),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              color: isConfirm
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
