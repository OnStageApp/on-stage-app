import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/song_version_modal.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongVersionDropdown extends ConsumerStatefulWidget {
  const SongVersionDropdown({super.key});

  @override
  ConsumerState<SongVersionDropdown> createState() =>
      _SongVersionDropdownState();
}

class _SongVersionDropdownState extends ConsumerState<SongVersionDropdown> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final songId = ref.read(songNotifierProvider).song.id;
      ref
          .read(songConfigurationNotifierProvider.notifier)
          .getSongConfig(songId ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = ref.watch(songConfigurationNotifierProvider).isCustom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Song Version',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        PreferencesActionTile(
          title: isCustom ? "Team's version" : 'Original',
          trailingIcon: Icons.keyboard_arrow_down_rounded,
          leadingWidget: Icon(
            Icons.filter_none,
            size: 16,
            color: context.colorScheme.outline,
          ),
          onTap: () {
            SongVersionModal.show(
              context: context,
            );
          },
        ),
      ],
    );
  }
}
