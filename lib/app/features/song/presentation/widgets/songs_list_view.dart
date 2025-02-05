import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/songs/song_tab_scope.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/songs_shimmer_list.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class SongsListView extends ConsumerWidget {
  const SongsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsState = ref.watch(songsNotifierProvider(SongTabScope.songs));

    return SliverPadding(
      padding: defaultScreenHorizontalPadding,
      sliver: songsState.isLoadingWithShimmer
          ? const SongsShimmerList()
          : songsState.songs.isEmpty && !songsState.isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Text('No Songs'),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songsState.filteredSongs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: SongTile(
                          song: song,
                          songTabScope: SongTabScope.songs,
                        ),
                      );
                    },
                    childCount: songsState.filteredSongs.length,
                  ),
                ),
    );
  }
}
