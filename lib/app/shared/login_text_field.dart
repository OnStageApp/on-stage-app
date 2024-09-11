import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    required this.label,
    super.key,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.textInputType,
    this.errorString,
    this.isBorderVisible = false,
    this.height = 42,
    this.controller,
    this.validator,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final String? errorString;
  final bool isBorderVisible;
  final double height;
  final String label;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.labelLarge),
        const SizedBox(height: Insets.smallNormal),
        SizedBox(
          child: TextFormField(
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            cursorColor: lightColorScheme.onSurfaceVariant,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            style: context.textTheme.bodyMedium,
            obscureText: obscureText,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.transparent,
              filled: true,
              hintText: hintText,
              hintStyle: context.textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: _getBorderSide(Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: _getBorderSide(Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (errorString != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorString ?? '',
              style: context.textTheme.bodySmall!
                  .copyWith(color: lightColorScheme.error),
            ),
          ),
      ],
    );
  }

  BorderSide _getBorderSide(Color color) {
    return BorderSide(
      color: errorString == null ? color : lightColorScheme.error,
      width: errorString == null ? 1 : 1.5,
    );
  }
}
