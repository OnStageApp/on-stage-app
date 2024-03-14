import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/dummy_data/user_dummy.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class FavoriteSongsScreen extends ConsumerStatefulWidget {
  const FavoriteSongsScreen({super.key});

  @override
  FavoriteSongsScreenState createState() => FavoriteSongsScreenState();
}

class FavoriteSongsScreenState extends ConsumerState<FavoriteSongsScreen> {
  List<SongModel> _songs = List.empty(growable: true);
  final List<String> _favSongsIds = ['65e74b72ccdb244182cd0c26'];
  final List<SongOverview> _favSongs = UserDummy.userModel.profile.favoriteSongs;

  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _isSearchedFocused();
   // Future.microtask(_fetchFavoriteSongs);
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

  // Future<void> _fetchFavoriteSongs() async {
  //
  //   for (var id in _favSongsIds) {
  //     await ref.read(songNotifierProvider.notifier).getSongById(id);
  //     _favSongs.add( ref.watch(songNotifierProvider).copyWith());
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const StageAppBar(
        title: 'Favorites',
        isBackButtonVisible: true,
      ),
      // body: ref.watch(songsNotifierProvider).isLoading
      //     ? const OnStageLoadingIndicator()
        body
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
        const SizedBox(height: Insets.large),
        Padding(
          padding: defaultScreenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isSearching)

              const SizedBox(height: Insets.medium),
              if (ref.watch(loadingProvider.notifier).state)
                _buildLoadingIndicator()
              else
                _buildFavoriteSongs(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFavoriteSongs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _favSongs.length,
      itemBuilder: (context, index) {
        final song = _favSongs[index];

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
