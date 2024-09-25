import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/enums/song_view.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SongViewToggle extends ConsumerWidget {
  const SongViewToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ToggleSwitch(
          initialLabelIndex: SongViewEnum.values.indexOf(
            ref.watch(userSettingsNotifierProvider).songView ??
                SongViewEnum.american,
          ),
          borderWidth: 5,
          activeFgColor: context.colorScheme.onSurfaceVariant,
          fontSize: 16,
          inactiveFgColor: context.colorScheme.onSurface,
          activeBgColor: [context.colorScheme.primary],
          inactiveBgColor: context.colorScheme.onSurfaceVariant,
          minWidth: double.infinity,
          minHeight: 38,
          cornerRadius: 10,
          totalSwitches: 3,
          radiusStyle: true,
          labels: SongViewEnum.values.map((e) => e.name).toList(),
          onToggle: (index) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .updateSongView(SongViewEnum.values[index ?? 0]);
            if (kDebugMode) {
              print('switched to: $index');
            }
          },
        ),
      ),
    );
  }
}
