import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceSelector<T> extends StatelessWidget {
  final String label;
  final String placeholder;
  final T? selectedValue;
  final String Function(T?) displayValue;
  final VoidCallback onTap;
  final FormFieldValidator<T?>? validator;

  const PreferenceSelector({
    required this.label,
    required this.placeholder,
    required this.selectedValue,
    required this.displayValue,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Insets.small),
          PreferencesActionTile(
            title: selectedValue != null
                ? displayValue(selectedValue)
                : placeholder,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onTap: onTap,
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                state.errorText!,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
