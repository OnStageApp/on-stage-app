import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/user_dummy.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class FavoriteSongsScreen extends ConsumerStatefulWidget {
  const FavoriteSongsScreen({super.key});

  @override
  FavoriteSongsScreenState createState() => FavoriteSongsScreenState();
}

class FavoriteSongsScreenState extends ConsumerState<FavoriteSongsScreen> {
  final List<SongOverview> _favSongs =
      UserDummy.userModel.profile.favoriteSongs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Favorites',
        isBackButtonVisible: true,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: defaultScreenHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Insets.medium),
              if (ref.watch(loadingProvider.notifier).state)
                const OnStageLoadingIndicator()
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
        final isLastSong = index == _favSongs.length - 1;

        return Column(
          children: [
            // SongTile(song: song),
            if (!isLastSong)
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
}
