import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/preferences/preferences_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/chord_view_mode_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/chord_view_mode_enum.dart';

class PreferencesViewMode extends ConsumerWidget {
  const PreferencesViewMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View Mode',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: Insets.small),
        PreferencesActionTile(
          leadingWidget: Text(
            ref.watch(preferencesNotifierProvider).chordViewMode.example,
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.outline),
          ),
          title: ref.watch(preferencesNotifierProvider).chordViewMode.name,
          trailingIcon: Icons.keyboard_arrow_down_rounded,
          onTap: () {
            ChordViewModeModal.show(
              context: context,
            );
          },
        ),
      ],
    );
  }
}
