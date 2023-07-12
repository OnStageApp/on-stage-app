import 'package:flutter/material.dart';
import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/song/domain/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/song_author_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  late List<Song> _songs;
  final FocusNode _focusNode = FocusNode();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _songs = SongDummy.songs;
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
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Songs',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            const SizedBox(height: Insets.medium),
            StageSearchBar(
              focusNode: _focusNode,
              controller: searchController,
              onClosed: () {
                _songs = SongDummy.songs;
              },
              onChanged: _getSearchedSongs,
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
                chord: 'C# major',
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

  void _getSearchedSongs(String value) {
    return setState(() {
      _songs = SongDummy.songs
          .where(
            (song) =>
                song.title.toLowerCase().contains(value) ||
                song.artist.fullName.toLowerCase().contains(value) ||
                song.lyrics.toLowerCase().contains(value),
          )
          .toList();
    });
  }
}
