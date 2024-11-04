import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    required this.text,
    required this.isEnabled,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String text;
  final bool isEnabled;
  final void Function()? onPressed;
  final bool isLoading;

  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, 54),
        ),
        splashFactory: InkRipple.splashFactory,
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: context.colorScheme.primaryContainer,
              width: 1.6,
            ),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          isEnabled
              ? backgroundColor ?? context.colorScheme.onSurfaceVariant
              : context.colorScheme.outlineVariant,
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return context.colorScheme.primaryContainer.withOpacity(0.1);
            }
            return null;
          },
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: isLoading
          ? const SizedBox(
              height: 24,
              child: LoadingIndicator(
                colors: [Colors.white],
                indicatorType: Indicator.lineSpinFadeLoader,
              ),
            )
          : Text(
              text,
              style: context.textTheme.titleMedium!.copyWith(
                color: isEnabled
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onPrimary,
              ),
            ),
    );
  }
}
