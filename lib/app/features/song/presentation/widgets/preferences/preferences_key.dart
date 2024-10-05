import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class PreferencesKey extends ConsumerWidget {
  const PreferencesKey({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: Insets.small),
        PreferencesActionTile(
          leadingWidget: Assets.icons.musicNote.svg(
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              context.colorScheme.outline,
              BlendMode.srcIn,
            ),
          ),
          title: ref.watch(songNotifierProvider).song.originalKey?.name ?? '',
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          onTap: () {
            ChangeKeyModal.show(
              context: context,
              songKey: ref.watch(songNotifierProvider).song.originalKey!,
            );
          },
        ),
      ],
    );
  }
}
