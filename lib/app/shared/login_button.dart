import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.text,
    required this.onPressed,
    required this.isEnabled,
    required this.splashColor,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.asset,
    super.key,
  });

  final String text;
  final void Function() onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final String? asset;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, 54),
        ),
        splashFactory: InkRipple.splashFactory,
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor ?? context.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          isEnabled
              ? backgroundColor ?? context.colorScheme.primary
              : context.colorScheme.outlineVariant,
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return splashColor.withOpacity(0.1);
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
          : Row(
              children: [
                if (asset != null)
                  SizedBox(
                    width: 24,
                    child: SvgPicture.asset(
                      asset!,
                      color: context.colorScheme.surfaceDim,
                    ),
                  ),
                const Spacer(),
                Text(
                  text,
                  style: context.textTheme.titleMedium!.copyWith(
                    color: textColor ?? context.colorScheme.onPrimary,
                  ),
                ),
                const Spacer(),
                if (asset != null) const SizedBox(width: 24),
              ],
            ),
    );
  }
}
