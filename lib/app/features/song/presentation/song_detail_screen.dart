import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  const SongDetailScreen(
    this.songId, {
    super.key,
  });

  final int songId;

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  SongModel? song;

  @override
  void initState() {
    // song = ref.read(songNotifierProvider.notifier).getSong(widget.songId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Song',
      ),
      body: song == null
          ? const LoadingIndicator(indicatorType: Indicator.lineScale)
          : const Column(
              children: [
                Text('Song Detail'),
              ],
            ),
    );
  }
}
