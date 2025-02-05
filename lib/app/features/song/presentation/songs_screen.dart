import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/load_more_button.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/songs_navigation_header.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_state.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/songs_list_view.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  SongsScreenState createState() => SongsScreenState();
}

class SongsScreenState extends ConsumerState<SongsScreen> {
  final _pageController = PageController(initialPage: 0);
  final _searchController = TextEditingController();
  var _currentPage = 0;

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
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
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

    return Container(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: '',
          titleWidget: NavigationHeader(
            isLibrarySelected: _currentPage == 1,
            onSelectionChanged: (isLibrary) {
              setState(() {
                _currentPage = isLibrary ? 1 : 0;
              });
              ref
                  .read(searchNotifierProvider.notifier)
                  .setLibraryFilter(isLibrary: isLibrary);
              _pageController.animateToPage(
                isLibrary ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          trailing: _buildAddSongsButton(context, ref),
        ),
        body: Column(
          children: [
            Padding(
              padding: defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: Insets.small),
                  Hero(
                    tag: 'searchBar',
                    child: StageSearchBar(
                      focusNode: FocusNode(),
                      controller: _searchController,
                      showFilter: true,
                      onClosed: () {
                        if (context.canPop()) context.pop();
                        _searchController.clear();
                      },
                      onChanged: (value) {
                        ref
                            .read(searchNotifierProvider.notifier)
                            .setText(value);
                      },
                    ),
                  ),
                  const SizedBox(height: Insets.large),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {},
                children: [
                  _SongsListContent(
                    isLibrary: false,
                    songsState: songsState,
                    searchState: searchState,
                  ),
                  _SongsListContent(
                    isLibrary: true,
                    songsState: songsState,
                    searchState: searchState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSongsButton(BuildContext context, WidgetRef ref) {
    if (!ref.watch(permissionServiceProvider).hasAccessToEdit) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: IconButton(
        style: IconButton.styleFrom(
          visualDensity: VisualDensity.compact,
          highlightColor: context.colorScheme.surfaceBright,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          context.goNamed(AppRoute.createSongInfo.name);
        },
        icon: Icon(Icons.add, color: context.colorScheme.surfaceDim),
      ),
    );
  }
}

class _SongsListContent extends ConsumerWidget {
  const _SongsListContent({
    required this.isLibrary,
    required this.songsState,
    required this.searchState,
  });

  final bool isLibrary;
  final SongsState songsState;
  final SearchState searchState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(songsNotifierProvider.notifier).getSongs(
              songFilter: searchState.toSongFilter(),
            );
      },
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SongsListView(),
          if (songsState.hasMore)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: LoadMoreButton(
                    onPressed: songsState.isLoading
                        ? () {}
                        : () => ref
                            .read(songsNotifierProvider.notifier)
                            .loadMoreSongs(
                              searchState.toSongFilter(),
                            ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
