import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/stage_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongChordTile extends StatefulWidget {
  const SongChordTile({
    required this.song,
    super.key,
  });

  final SongModel song;

  @override
  State<SongChordTile> createState() => _SongChordTileState();
}

class _SongChordTileState extends State<SongChordTile> {
  @override
  Widget build(BuildContext context) {
    return StageTile(
      title: widget.song.title ?? '',
      description: 'widget.song.artist' ?? '',
      trailing: _buildSongKeyWidget(context),
    );
  }

  Container _buildSongKeyWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.smaller,
        horizontal: Insets.smallNormal,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Text(
        widget.song.key ?? '',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white),
        maxLines: 1,
      ),
    );
  }
}
