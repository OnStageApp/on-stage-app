import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/songs/song_tab_scope.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LibrarySection extends ConsumerWidget {
  const LibrarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedSongs =
        ref.watch(songsNotifierProvider(SongTabScope.profile)).savedSongs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Library',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        PreferencesActionTile(
          title: 'Saved Songs',
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          height: 54,
          onTap: () {
            context.goNamed(
              AppRoute.favorites.name,
              queryParameters: {
                'songTabScope': SongTabScope.profile.name,
              },
            );
          },
          suffixWidget: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${savedSongs.length}',
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PreferencesActionTile(
          title: 'About',
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          height: 54,
          onTap: () {
            context.goNamed(AppRoute.about.name);
          },
        ),
      ],
    );
  }
}
