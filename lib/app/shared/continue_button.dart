import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.text,
    required this.onPressed,
    required this.isEnabled,
    this.hasShadow = true,
    super.key,
  });

  final String text;
  final void Function() onPressed;
  final bool isEnabled;

  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: context.colorScheme.surface,
                  blurRadius: 30,
                  spreadRadius: 35,
                  offset: const Offset(0, 24),
                ),
              ]
            : [],
      ),
      child: TextButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, 54),
          ),
          splashFactory: InkRipple.splashFactory,
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            isEnabled
                ? context.colorScheme.primary
                : context.colorScheme.outlineVariant,
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return context.colorScheme.surface.withOpacity(0.1);
              }
              return null;
            },
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.titleMedium!.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
