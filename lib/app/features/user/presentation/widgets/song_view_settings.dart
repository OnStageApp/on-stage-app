import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
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
      ],
    );
  }
}
