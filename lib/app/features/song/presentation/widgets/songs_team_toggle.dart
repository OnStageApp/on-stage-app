import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SongsTeamToggle extends ConsumerWidget {
  const SongsTeamToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamFilter = ref.watch(searchNotifierProvider).teamFilter ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ToggleSwitch(
          initialLabelIndex: teamFilter ? 1 : 0,
          borderWidth: 5,
          activeFgColor: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 16,
          inactiveFgColor: Theme.of(context).colorScheme.onSurface,
          activeBgColor: [Theme.of(context).colorScheme.primary],
          inactiveBgColor: Theme.of(context).colorScheme.onSurfaceVariant,
          minWidth: double.infinity,
          minHeight: 38,
          cornerRadius: 10,
          totalSwitches: 2,
          radiusStyle: true,
          labels: const ['All Songs', 'Team Songs'],
          onToggle: (index) {
            ref
                .read(searchNotifierProvider.notifier)
                .setTeamFilter(teamFilter: index == 1);

            if (kDebugMode) {
              print('Switched to: ${index == 1 ? 'Team Songs' : 'All Songs'}');
            }
          },
        ),
      ),
    );
  }
}
