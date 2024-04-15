import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.text,
    required this.onPressed,
    required this.isEnabled,
    this.hasShadow = false,
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
                const BoxShadow(
                  color: Color(0xFFF4F4F4),
                  blurRadius: 24,
                  offset: Offset(0, -16),
                  spreadRadius: 8,
                ),
              ]
            : [],
      ),
      height: 54,
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            isEnabled ? const Color(0xFF1996FF) : const Color(0xFFBDBDBD),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
