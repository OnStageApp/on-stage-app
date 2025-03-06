import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceSelector<T> extends StatelessWidget {
  const PreferenceSelector({
    required this.label,
    required this.placeholder,
    required this.selectedValue,
    required this.displayValue,
    required this.onTap,
    super.key,
    this.validator,
    this.icon,
    this.requiredField = false,
  });

  final String label;
  final String placeholder;
  final T? selectedValue;
  final String Function(T?) displayValue;
  final VoidCallback onTap;
  final FormFieldValidator<T?>? validator;
  final IconData? icon;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return FormField<T?>(
      initialValue: selectedValue,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        // Update state when value changes
        if (state.value != selectedValue) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(selectedValue);
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                if (requiredField)
                  Text(
                    ' *',
                    style: context.textTheme.titleSmall!
                        .copyWith(color: context.colorScheme.error),
                  ),
              ],
            ),
            const SizedBox(height: Insets.small),
            PreferencesActionTile(
              leadingWidget: icon != null
                  ? Icon(
                      icon,
                      color: context.colorScheme.outline,
                    )
                  : null,
              title: selectedValue != null
                  ? displayValue(selectedValue)
                  : placeholder,
              trailingIcon: Icons.keyboard_arrow_down_rounded,
              onTap: () {
                onTap();
                state.didChange(
                  selectedValue,
                );
              },
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
        );
      },
    );
  }
}
