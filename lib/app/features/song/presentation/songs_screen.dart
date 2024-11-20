import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/songs_list_view.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  SongsScreenState createState() => SongsScreenState();
}

class SongsScreenState extends ConsumerState<SongsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsNotifierProvider.notifier).getSongs(
            isLoadingWithShimmer: true,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsNotifierProvider);
    final searchState = ref.watch(searchNotifierProvider);

    ref.listen<SearchState>(
      searchNotifierProvider,
      (previous, next) {
        if (previous != next) {
          ref.read(songsNotifierProvider.notifier).getSongs(
                songFilter: next.toSongFilter(),
              );
        }
      },
    );
    return Scaffold(
      appBar: StageAppBar(
        titleWidget: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: songsState.songs.length.toString(),
                style: context.textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  color: context.colorScheme.surfaceDim,
                ),
              ),
              TextSpan(
                text: ' Songs',
                style: context.textTheme.headlineLarge!.copyWith(
                  fontSize: 28,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        title: '',
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(songsNotifierProvider.notifier).getSongs();
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
                          final songFilter = searchState.toSongFilter();
                          ref
                              .read(searchNotifierProvider.notifier)
                              .setText(value);
                          ref.read(songsNotifierProvider.notifier).getSongs(
                                songFilter: songFilter.copyWith(
                                  search: value,
                                ),
                              );
                        },
                      ),
                    ),
                    const SizedBox(height: Insets.large),
                  ],
                ),
              ),
            ),
            const SongsListView(),
          ],
        ),
      ),
    );
  }
}
