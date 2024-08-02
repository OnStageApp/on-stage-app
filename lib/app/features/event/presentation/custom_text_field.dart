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
  });

  final String label;
  final String hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall!.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: Insets.small),
        TextField(
          enabled: enabled ?? true,
          style: context.textTheme.titleMedium!.copyWith(
            color: context.colorScheme.onSurface,
          ),
          controller: controller,
          decoration: WidgetUtils.getDecorations(context, icon, hintText: hint),
        ),
      ],
    );
  }
}
