import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
          leadingWidget: SvgPicture.asset(
            'assets/icons/music_note.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF74777F),
              BlendMode.srcIn,
            ),
          ),
          title: ref.watch(songNotifierProvider).song.key!,
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          onTap: () {
            ChangeKeyModal.show(
              context: context,
              // tonality: ref.watch(songNotifierProvider).song.key!,
              tonality: const SongKey(
                name: 'C',
              ),
            );
          },
        ),
      ],
    );
  }
}
