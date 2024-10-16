import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/shared/stage_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongLibraryToggle extends ConsumerWidget {
  const SongLibraryToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamFilter = ref.watch(searchNotifierProvider).teamFilter ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Song Library',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        StageToggle(
          initialIndex: teamFilter ? 1 : 0,
          labels: const ['All Songs', 'Team Songs'],
          totalSwitches: 2,
          onToggle: (index) {
            ref
                .read(searchNotifierProvider.notifier)
                .setTeamFilter(teamFilter: index == 1);

            if (kDebugMode) {
              print('Switched to: ${index == 1 ? 'Team Songs' : 'All Songs'}');
            }
          },
        ),
      ],
    );
  }
}
