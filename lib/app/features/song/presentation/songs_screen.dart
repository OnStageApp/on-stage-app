import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  SongsScreenState createState() => SongsScreenState();
}

class SongsScreenState extends ConsumerState<SongsScreen> {
  List<SongModel> _songs = List.empty(growable: true);
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _isSearchedFocused();
    super.initState();
  }

  void _isSearchedFocused() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isSearching = true;
        });
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO:uncomment
    // _songs = ref.watch(songsNotifierProvider).filteredSongs;
    _songs = SongDummy.playlist;
    return Scaffold(
      appBar: StageAppBar(
        titleWidget: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: ref.read(songsNotifierProvider).songs.length.toString(),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  color: const Color(0xFF7F818B),
                ),
              ),
              TextSpan(
                text: ' Songs',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  color: context.colorScheme.shadow,
                ),
              ),
            ],
          ),
        ),
        title: '',
      ),
      body: _buildContent(context),
      // body: ref.watch(songsNotifierProvider).isLoading
      //     ? const OnStageLoadingIndicator()
      //     : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: Insets.small),
        Padding(
          padding: defaultScreenHorizontalPadding,
          child: Hero(
            tag: 'searchBar',
            child: StageSearchBar(
              focusNode: _focusNode,
              controller: _searchController,
              onClosed: () {
                if (context.canPop()) context.pop();
                _searchController.clear();
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  _focusNode.unfocus();
                } else {
                  ref.read(songsNotifierProvider.notifier).searchSongs(
                        searchedText: value,
                      );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: Insets.large),
        Padding(
          padding: defaultScreenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isSearching)
                Text(
                  'Recently added',
                  style: context.textTheme.headlineMedium,
                ),
              const SizedBox(height: Insets.medium),
              if (ref.watch(loadingProvider.notifier).state)
                Container(
                  alignment: Alignment.center,
                  height: 10,
                  width: 10,
                  child: const OnStageLoadingIndicator(),
                )
              else
                _buildSongs(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSongs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        final isLastSong = index == _songs.length - 1;

        return Column(
          children: [
            const SizedBox(height: 6),
            SongTile(song: song),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
