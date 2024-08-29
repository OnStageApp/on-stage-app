import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
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
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: TextFormField(
            onChanged: onChanged,
            cursorColor: lightColorScheme.onSurfaceVariant,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            style: context.textTheme.labelMedium,
            obscureText: obscureText,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: context.textTheme.labelMedium,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderSide: _getEnabledBorder(),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: _getBorderSide(lightColorScheme.shadow),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (errorString != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(errorString ?? '', style: context.textTheme.labelLarge),
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

  BorderSide _getEnabledBorder() {
    return isBorderVisible
        ? _getBorderSide(lightColorScheme.surface)
        : _getBorderSide(lightColorScheme.surface);
  }
}
