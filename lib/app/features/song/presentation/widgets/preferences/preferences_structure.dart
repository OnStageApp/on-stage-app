import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/song_structure_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class PreferencesSongStructure extends ConsumerWidget {
  const PreferencesSongStructure({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Structure',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: Insets.smallNormal),
        PreferencesActionTile(
          leadingWidget: Assets.icons.songStructure.svg(
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              context.colorScheme.outline,
              BlendMode.srcIn,
            ),
          ),
          title: 'Song Structure',
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          onTap: () {
            SongStructureModal.show(
              context: context,
              ref: ref,
              onSave: (isOrderPage) {
                if (isOrderPage) {
                  _changeOrder(ref, context);
                } else {
                  _addStructureList(ref, isOrderPage);
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _addStructureList(WidgetRef ref, bool isOrderPage) {
    final newStructure =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();

    final oldStructure = ref.watch(songNotifierProvider).song.structure;
    ref.read(songNotifierProvider.notifier).updateStructureOnSong([
      ...?oldStructure,
      ...newStructure,
    ]);

    ref.read(songPreferencesControllerProvider.notifier).clearStructureItems();
  }

  void _changeOrder(WidgetRef ref, BuildContext context) {
    final songPrefsController = ref.watch(songPreferencesControllerProvider);
    final structure = songPrefsController.structureItems;
    ref.read(songNotifierProvider.notifier).updateStructureOnSong(structure);

    context.popDialog();
  }
}
