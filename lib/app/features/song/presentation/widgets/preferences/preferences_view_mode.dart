import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/presentation/chord_view_mode_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
            ref.watch(userSettingsNotifierProvider).songView?.example ?? '',
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.outline),
          ),
          title: ref.watch(userSettingsNotifierProvider).songView?.name ?? '',
          trailingIcon: Icons.keyboard_arrow_down_rounded,
          onTap: () {
            SongViewModeModal.show(
              context: context,
            );
          },
        ),
      ],
    );
  }
}
