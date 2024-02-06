import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/song_chord_tile.dart';

class Playlist extends StatelessWidget {
  const Playlist({
    required this.playlist,
    super.key,
  });

  final List<SongModel> playlist;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        final song = playlist[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SongChordTile(song: song),
        );
      },
    );
  }
}
