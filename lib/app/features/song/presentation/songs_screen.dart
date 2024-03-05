import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/song/application/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
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
    _songs = ref.watch(songsNotifierProvider).filteredSongs;
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Songs',
      ),
      body: ref.watch(songsNotifierProvider).isLoading
          ? const OnStageLoadingIndicator()
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: Insets.medium),
        Padding(
          padding: defaultScreenHorizontalPadding,
          child: Hero(
            tag: 'searchBar',
            child: StageSearchBar(
              focusNode: _focusNode,
              controller: searchController,
              onClosed: () {
                if (context.canPop()) context.pop();
                searchController.clear();
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
        if (!_isSearching) ...[
          const SizedBox(height: Insets.medium),
          Padding(
            padding: defaultScreenHorizontalPadding,
            child: Text(
              'Upcoming Events',
              style: context.textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: Insets.medium),
          Container(
            padding: EdgeInsets.zero,
            child: _buildUpcomingEvents(),
          ),
        ],
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
                _buildLoadingIndicator()
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

        return Column(
          children: [
            SongTile(song: song),
            Divider(
              color: context.colorScheme.outlineVariant,
              thickness: 1,
              height: Insets.medium,
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpcomingEvents() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: EventTileEnhanced(
              title: 'Duminică seara',
              hour: '18:00',
              location: 'Sala El-Shaddai',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: EventTileEnhanced(
              title: 'Duminică seara',
              hour: '18:00',
              location: 'Sala El-Shaddai',
            ),
          ),
        ],
      ),
    );
  }

  Center _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
        ),
      ),
    );
  }
}
