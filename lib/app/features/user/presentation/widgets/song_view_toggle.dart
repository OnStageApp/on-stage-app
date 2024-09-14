import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SongViewToggle extends StatelessWidget {
  const SongViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        borderColor: [
          context.colorScheme.onSurfaceVariant,
        ],
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
        labels: const ['Chords', 'Numeric', 'Lyrics Only'],
        onToggle: (index) {
          if (kDebugMode) {
            print('switched to: $index');
          }
        },
      ),
    );
  }
}
