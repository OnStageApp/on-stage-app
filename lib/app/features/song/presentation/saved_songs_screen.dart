import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SavedSongsScreen extends ConsumerStatefulWidget {
  const SavedSongsScreen({super.key});

  @override
  SavedSongsScreenState createState() => SavedSongsScreenState();
}

class SavedSongsScreenState extends ConsumerState<SavedSongsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsNotifierProvider.notifier).getSavedSongs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsNotifierProvider);

    return Scaffold(
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: '',
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(songsNotifierProvider.notifier).getSavedSongs();
        },
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: defaultScreenHorizontalPadding,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${songsState.savedSongs.length} ',
                            style: context.textTheme.headlineLarge?.copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                          ),
                          TextSpan(
                            text: 'Saved Songs',
                            style: context.textTheme.headlineLarge!.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Insets.normal),
                    StageSearchBar(
                      focusNode: FocusNode(),
                      controller: _searchController,
                      onClosed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                        _searchController.clear();
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: Insets.large),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: defaultScreenHorizontalPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = songsState.savedSongs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SongTile(song: song),
                    );
                  },
                  childCount: songsState.savedSongs.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
