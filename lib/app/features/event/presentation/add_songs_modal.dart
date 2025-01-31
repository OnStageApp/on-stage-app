import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/load_more_button.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/songs_navigation_header.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class AddSongsModal extends ConsumerStatefulWidget {
  static void show({
    required BuildContext context,
    required VoidCallback onSongsAdded,
  }) {
    AdaptiveModal.show(
      context: context,
      child: AddSongsModal(onSongsAdded: onSongsAdded),
    );
  }

  const AddSongsModal({required this.onSongsAdded, super.key});

  final VoidCallback onSongsAdded;

  @override
  AddSongsModalState createState() => AddSongsModalState();
}

class AddSongsModalState extends ConsumerState<AddSongsModal> {
  final _pageController = PageController();
  final _searchController = TextEditingController();
  final _selectedSongs = <SongOverview>{};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsNotifierProvider.notifier).getSongs(
            isLoadingWithShimmer: true,
          );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: context.colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _AddSongsFooter(
        selectedSongs: _selectedSongs,
        onSave: () => _onSaved(context),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: NavigationHeader(
              isLibrarySelected: _currentPage == 1,
              onSelectionChanged: (isLibrary) {
                _pageController.animateToPage(
                  isLibrary ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: StageSearchBar(
              focusNode: FocusNode(),
              controller: _searchController,
              showFilter: true,
              expandFilterModal: true,
              onClosed: _searchController.clear,
              onChanged: (value) =>
                  ref.read(searchNotifierProvider.notifier).setText(value),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                ref.read(searchNotifierProvider.notifier).setLibraryFilter(
                      isLibrary: index == 1,
                    );
              },
              children: [
                _SongsSelectionContent(
                  isLibrary: false,
                  selectedSongs: _selectedSongs,
                  onSongToggle: _toggleSongSelection,
                ),
                _SongsSelectionContent(
                  isLibrary: true,
                  selectedSongs: _selectedSongs,
                  onSongToggle: _toggleSongSelection,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSongSelection(SongOverview song) {
    setState(() {
      if (_selectedSongs.contains(song)) {
        _selectedSongs.remove(song);
      } else {
        _selectedSongs.add(song);
      }
    });
  }

  void _onSaved(BuildContext context) {
    final eventId = ref.watch(eventNotifierProvider).event?.id;
    if (eventId == null) return;

    ref.read(eventItemsNotifierProvider.notifier).addSongItems(
          _selectedSongs.toList(),
          eventId,
        );

    context.popDialog();
    widget.onSongsAdded();
  }
}

class _SongsSelectionContent extends ConsumerWidget {
  const _SongsSelectionContent({
    required this.isLibrary,
    required this.selectedSongs,
    required this.onSongToggle,
  });

  final bool isLibrary;
  final Set<SongOverview> selectedSongs;
  final ValueChanged<SongOverview> onSongToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsState = ref.watch(songsNotifierProvider);
    final searchState = ref.watch(searchNotifierProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: songsState.songs.length + 1,
      itemBuilder: (context, index) {
        if (index == songsState.songs.length) {
          return _buildBottomItem(
            hasMore: songsState.hasMore,
            isLoading: songsState.isLoading,
            onLoadMore: () => ref
                .read(songsNotifierProvider.notifier)
                .loadMoreSongs(searchState.toSongFilter()),
          );
        }

        // Regular song item
        final song = songsState.songs[index];
        return _SongSelectionTile(
          song: song,
          isSelected: selectedSongs.contains(song),
          onTap: () => onSongToggle(song),
        );
      },
    );
  }

  Widget _buildBottomItem({
    required bool hasMore,
    required bool isLoading,
    required VoidCallback onLoadMore,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 120),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: hasMore
          ? LoadMoreButton(
              onPressed: isLoading ? () {} : onLoadMore,
            )
          : const SizedBox(),
    );
  }
}

class _SongSelectionTile extends StatelessWidget {
  const _SongSelectionTile({
    required this.song,
    required this.isSelected,
    required this.onTap,
  });

  final SongOverview song;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (song.teamId.isNotNullEmptyOrWhitespace)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Team's Song"),
                      ),
                    Text(
                      song.title ?? '',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            song.artist?.name ?? '',
                            style: context.textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SongKeyLabelWidget(
                          songKey: song.key?.name ?? '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 20,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSongsFooter extends StatelessWidget {
  const _AddSongsFooter({
    required this.selectedSongs,
    required this.onSave,
  });

  final Set<SongOverview> selectedSongs;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ContinueButton(
        text: 'Add',
        onPressed: selectedSongs.isEmpty ? () {} : onSave,
        isEnabled: selectedSongs.isNotEmpty,
      ),
    );
  }
}
