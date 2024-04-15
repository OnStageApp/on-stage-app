import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/song_preferences_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongAppBarLeading extends ConsumerWidget {
  const SongAppBarLeading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onPressed: () {
            ChangeKeyModal.show(
              context: context,
              tonality: ref.watch(songNotifierProvider).song.songKey!,
            );
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ref.watch(songNotifierProvider.notifier).getKeyName(),
              style: context.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          width: Insets.small,
        ),
        InkWell(
          onTap: () {
            SongPreferencesModal.show(
              context: context,
              tonality: ref.watch(songNotifierProvider).song.songKey!,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/icons/mixer_horizontal.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF74777F),
                BlendMode.srcIn,
              ),
              height: 16,
              width: 16,
            ),
          ),
        ),
      ],
    );
  }
}
