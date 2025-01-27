import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/stage_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongViewSettings extends ConsumerWidget {
  const SongViewSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Song View',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        StageToggle(
          initialIndex: SongViewMode.values.indexOf(
            ref.watch(userSettingsNotifierProvider).songView ??
                SongViewMode.american,
          ),
          labels: SongViewMode.values.map((e) => e.name).toList(),
          totalSwitches: SongViewMode.values.length,
          onToggle: (index) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .updateSongView(SongViewMode.values[index ?? 0]);

            if (kDebugMode) {
              print('Switched to: $index');
            }
          },
        ),
        const SizedBox(height: 12),
        CustomSwitchListTile(
          title: 'Md Notes',
          icon: LucideIcons.sticky_note,
          value:
              ref.watch(userSettingsNotifierProvider).displayMdNotes ?? false,
          onSwitch: (value) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .setDisplayMdNotes(displayMdNotes: value);
          },
        ),
        const SizedBox(height: 12),
        CustomSwitchListTile(
          title: 'Song Details',
          icon: LucideIcons.list_collapse,
          value: ref.watch(userSettingsNotifierProvider).displaySongDetails ??
              false,
          onSwitch: (value) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .setDisplaySongDetails(displaySongDetails: value);
          },
        ),
      ],
    );
  }
}
