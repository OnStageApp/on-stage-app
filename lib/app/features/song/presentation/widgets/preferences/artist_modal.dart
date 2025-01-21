import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artists_notifier.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_filter.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/load_more_button.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/add_artist_modal.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class ArtistModal extends ConsumerStatefulWidget {
  const ArtistModal(
    this.onArtistSelected, {
    this.showAddArtistButton = true,
    super.key,
  });

  final void Function(Artist) onArtistSelected;
  final bool showAddArtistButton;

  @override
  ArtistModalState createState() => ArtistModalState();

  static void show({
    required BuildContext context,
    required void Function(Artist) onArtistSelected,
    bool showAddArtistButton = true,
  }) {
    AdaptiveModal.show(
      context: context,
      child: ArtistModal(
        onArtistSelected,
        showAddArtistButton: showAddArtistButton,
      ),
    );
  }
}

class ArtistModalState extends ConsumerState<ArtistModal> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(artistsNotifierProvider.notifier).getArtists();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    logger.i('Search query: $query');
    ref.read(artistsNotifierProvider.notifier).getArtists(
          search: query.isEmpty ? null : ArtistFilter(search: query),
        );
  }

  Future<void> _loadMore() async {
    final query = _searchController.text;
    await ref.read(artistsNotifierProvider.notifier).getMoreArtists(
          search: query.isEmpty ? null : ArtistFilter(search: query),
        );
  }

  @override
  Widget build(BuildContext context) {
    final artistsState = ref.watch(artistsNotifierProvider);
    final artists = artistsState.artists;
    final isLoading = artistsState.isLoading;
    final hasMore = artistsState.hasMore;
    final error = artistsState.error;

    return NestedScrollModal(
      buildHeader: () => ModalHeader(
        title: 'Select an Artist',
        leadingButton: widget.showAddArtistButton
            ? AddNewButton(
                onPressed: () async {
                  final newArtist = await AddArtistModal.show(
                    context: context,
                  );

                  if (newArtist != null) {
                    widget.onArtistSelected(newArtist);
                    if (context.mounted) {
                      context.popDialog();
                    }
                  } else {
                    // Only refresh the list if no artist was selected
                    ref.read(artistsNotifierProvider.notifier).resetArtists();
                    await ref
                        .read(artistsNotifierProvider.notifier)
                        .getArtists();
                  }
                },
              )
            : null,
      ),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            StageSearchBar(
              focusNode: _focusNode,
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $error',
                  style: TextStyle(color: context.colorScheme.error),
                ),
              )
            else if (isLoading && artists.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (artists.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No artists found'),
                ),
              )
            else
              Column(
                children: [
                  ...List.generate(
                    artists.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          artists[index].name,
                          style: context.textTheme.titleSmall,
                        ),
                        tileColor: _isItemChecked(index)
                            ? context.colorScheme.primary.withOpacity(0.1)
                            : context.colorScheme.onSurfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashColor: context.colorScheme.surfaceBright,
                        onTap: () {
                          widget.onArtistSelected(artists[index]);
                          context.popDialog();
                        },
                      ),
                    ),
                  ),
                  if (hasMore)
                    LoadMoreButton(
                      onPressed: _loadMore,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool _isItemChecked(int index) =>
      ref.watch(searchNotifierProvider).artistFilter ==
      ref.watch(artistsNotifierProvider).artists[index];
}
