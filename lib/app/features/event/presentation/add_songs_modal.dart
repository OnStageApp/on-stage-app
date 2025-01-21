import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddSongsModal extends ConsumerStatefulWidget {
  @override
  AddSongsModalState createState() => AddSongsModalState();

  static void show({
    required BuildContext context,
    required VoidCallback onSongsAdded,
  }) {
    AdaptiveModal.show(
      context: context,
      child: AddSongsModal(),
    );
  }
}

class AddSongsModalState extends ConsumerState<AddSongsModal> {
  final TextEditingController _searchController = TextEditingController();
  final List<SongOverview> _selectedSongs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsNotifierProvider.notifier).getSongs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildFooter: () => SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: ContinueButton(
            text: 'Add',
            onPressed:
                _selectedSongs.isNotEmpty ? () => _onSaved(context) : () {},
            isEnabled: _selectedSongs.isNotEmpty,
          ),
        ),
      ),
      buildHeader: () => const ModalHeader(title: 'Add Songs'),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            StageSearchBar(
              focusNode: FocusNode(),
              controller: _searchController,
              onClosed: _clearSearch,
              onChanged: _onSearch,
            ),
            const SizedBox(height: 12),
            _buildSongsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsList() {
    final songs = ref.watch(songsNotifierProvider).songs;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isSelected = _selectedSongs.contains(song);

        return InkWell(
          onTap: () => _toggleSongSelection(song),
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
                        Text(
                          song.title ?? '',
                          style: context.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
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
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
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
      },
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

    ref
        .read(eventItemsNotifierProvider.notifier)
        .addSongItems(_selectedSongs, eventId);
    context.popDialog();
  }

  void _onSearch(String value) {
    final searchState = ref.watch(searchNotifierProvider);
    final songFilter = searchState.toSongFilter();
    ref.read(searchNotifierProvider.notifier).setText(value);
    ref.read(songsNotifierProvider.notifier).getSongs(
          songFilter: songFilter.copyWith(search: value),
        );
  }

  void _clearSearch() {
    _searchController.clear();
  }
}
