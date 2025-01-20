import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/widget_utils.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    super.key,
    this.enabled,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.borderColor,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  final String? label;
  final String hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool? enabled;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Color? borderColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        const SizedBox(height: Insets.small),
        TextFormField(
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          focusNode: focusNode,
          enabled: enabled ?? true,
          style: context.textTheme.titleMedium!.copyWith(
            color: context.colorScheme.onSurface,
          ),
          onChanged: onChanged,
          controller: controller,
          decoration: WidgetUtils.getDecorations(context, icon, hintText: hint)
              .copyWith(
            suffixIcon: suffixIcon,
            errorStyle: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.error,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor ?? Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor ?? Colors.transparent,
              ),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'This field cannot be empty';
                }
                return null;
              },
        ),
      ],
    );
  }
}
