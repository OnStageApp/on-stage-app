import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';

import 'songs_shimmer_list.dart';

class SongsListView extends ConsumerWidget {
  const SongsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsState = ref.watch(songsNotifierProvider);
    final searchState = ref.watch(searchNotifierProvider);

    return SliverPadding(
      padding: defaultScreenHorizontalPadding,
      sliver: songsState.isLoadingWithShimmer
          ? const SongsShimmerList()
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = songsState.filteredSongs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SongTile(song: song),
                  );
                },
                childCount: songsState.filteredSongs.length,
              ),
            ),
    );
  }
}
