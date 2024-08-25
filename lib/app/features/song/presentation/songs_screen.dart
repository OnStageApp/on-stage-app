import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  SongsScreenState createState() => SongsScreenState();
}

class SongsScreenState extends ConsumerState<SongsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    ref.read(songsNotifierProvider.notifier).getSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsNotifierProvider);
    final isFocused = ref.watch(searchControllerProvider).isFocused;

    return Scaffold(
      appBar: StageAppBar(
        titleWidget: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: songsState.songs.length.toString(),
                style: context.textTheme.headlineLarge?.copyWith(
                  color: context.colorScheme.surfaceDim,
                ),
              ),
              TextSpan(
                text: ' Songs',
                style: context.textTheme.headlineLarge!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        title: '',
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await ref.read(songsNotifierProvider.notifier).getSongs();
            },
          ),
          SliverPadding(
            padding: defaultScreenHorizontalPadding,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Insets.small),
                  Hero(
                    tag: 'searchBar',
                    child: StageSearchBar(
                      focusNode: FocusNode(),
                      controller: _searchController,
                      showFilter: true,
                      onClosed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                        _searchController.clear();
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          ref.read(songsNotifierProvider.notifier).searchSongs(
                                searchedText: value,
                              );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: Insets.large),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !isFocused
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recently added',
                                style: context.textTheme.headlineMedium,
                              ),
                              const SizedBox(height: Insets.medium),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: defaultScreenHorizontalPadding,
            sliver: songsState.isLoading
                ? _buildShimmerList()
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
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                height: 70, // Adjust this height to match your SongTile height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
        childCount: 10, // Show 10 shimmer items while loading
      ),
    );
  }
}
