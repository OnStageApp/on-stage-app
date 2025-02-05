import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/songs/song_tab_scope.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class SavedSongsTile extends ConsumerWidget {
  const SavedSongsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(const Color(0x33FFFFFF)),
      onTap: () {
        context.pushNamed(
          AppRoute.favorites.name,
          queryParameters: {
            'songTabScope': SongTabScope.home.name,
          },
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.heartFilled.svg(
                  color: context.colorScheme.onSecondaryFixed,
                ),
                const SizedBox(width: Insets.small),
                Flexible(
                  child: AutoSizeText(
                    'Saved songs',
                    style: context.textTheme.titleLarge,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ref
                      .watch(songsNotifierProvider(SongTabScope.home))
                      .savedSongs
                      .length
                      .toString(),
                  style: context.textTheme.headlineLarge,
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Assets.icons.arrowForward.svg(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
