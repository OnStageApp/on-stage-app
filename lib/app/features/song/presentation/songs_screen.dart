import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/search/search_song_provider.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/song_author_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  SongsScreenState createState() => SongsScreenState();
}

class SongsScreenState extends ConsumerState<SongsScreen> {
  final List<Song> _songs = List.empty(growable: true);
  final FocusNode _focusNode = FocusNode();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _isSearchedFocused();
    super.initState();
  }

  void _isSearchedFocused() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isSearching = true;
        });
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _songs
      ..clear()
      ..addAll(ref.watch(searchSongProvider).songs);
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Songs',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            const SizedBox(height: Insets.medium),
            Hero(
              tag: 'searchBar',
              child: StageSearchBar(
                focusNode: _focusNode,
                controller: searchController,
                onClosed: () {
                  ref.invalidate(searchSongProvider);
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    _focusNode.unfocus();
                  }
                  ref.read(searchSongProvider.notifier).searchSongs(
                        searchedText: value,
                      );
                },
              ),
            ),
            if (!isSearching) ...[
              const SizedBox(height: Insets.medium),
              Text(
                'Upcoming',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: Insets.medium),
              const EventTile(
                title: 'Friday Night',
                description: 'Monday, 14 Feb',
              ),
            ],
            const SizedBox(height: Insets.medium),
            Text(
              'Songs (${_songs.length})',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: Insets.normal),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];

                return Column(
                  children: [
                    SongAndAuthorTile(song: song),
                    const SizedBox(height: Insets.smallNormal),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
