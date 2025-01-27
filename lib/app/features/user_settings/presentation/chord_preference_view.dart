import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user_settings/domain/chord_type_view_enum.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordPreferenceView extends StatelessWidget {
  const ChordPreferenceView({
    required this.selectedValue,
    required this.onTap,
    super.key,
    this.validator,
    this.icon,
  });

  final ChordViewPref? selectedValue;
  final VoidCallback onTap;
  final FormFieldValidator<ChordViewPref?>? validator;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FormField<ChordViewPref?>(
      initialValue: selectedValue,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        if (state.value != selectedValue) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(selectedValue);
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferencesActionTile(
              leadingWidget: Text(
                '${selectedValue?.icon}',
                style: context.textTheme.titleLarge,
              ),
              title: selectedValue?.description ?? '',
              color: context.colorScheme.onSurface,
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
