import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/lyrics/lyrics_renderer.dart';
import 'package:on_stage_app/app/features/song/application/song_detail_provider.dart';
import 'package:on_stage_app/app/shared/stage_detail_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  const SongDetailScreen(
    this.songId,
    this.songName, {
    super.key,
  });

  final int songId;
  final String songName;

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(
      songDetailsProvider(widget.songId),
    );
    return Scaffold(
      appBar: StageDetailAppBar(
        title: widget.songName,
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: song.when(
          loading: _buildLoadingIndicator,
          error: (error, stackTrace) => _buildError(error),
          data: (song) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Key: ${song.key}'),
                const Text('Structura: S1, R, B, C, B, I'),
                const SizedBox(
                  height: 20,
                ),
                LyricsRenderer(
                  widgetPadding: 16 + 10,
                  lyrics: song.lyrics,
                  textStyle:
                      context.textTheme.bodySmall!.copyWith(fontSize: 14),
                  chordStyle: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  structureStyle: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  onTapChord: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        error.toString(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: LoadingIndicator(
          colors: [Colors.black],
          indicatorType: Indicator.ballClipRotateMultiple,
        ),
      ),
    );
  }
}
