import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/presentation/chord_view_mode_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordsViewModeWidget extends ConsumerWidget {
  const ChordsViewModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferencesActionTile(
      leadingWidget: Text(
        ref.watch(userSettingsNotifierProvider).chordsView?.example ?? '',
        style: context.textTheme.titleMedium!
            .copyWith(color: context.colorScheme.outline),
      ),
      title: ref.watch(userSettingsNotifierProvider).chordsView?.name ?? '',
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      onTap: () {
        SongViewModeModal.show(
          context: context,
        );
      },
    );
  }
}
