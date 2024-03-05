import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    required this.song,
    super.key,
  });

  final SongModel song;

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.song.title ?? '',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
            ),
            const SizedBox(height: Insets.smaller),
            Row(
              children: [
                Text(
                  widget.song.artist ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                _buildCircle(context),
                _buildKey(context),
                _buildCircle(context),
                Text(
                  '148 bpm',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            setState(() {
              saved = !saved;
            });
          },
          child: Icon(
            saved ? Icons.bookmark : Icons.bookmark_border,
            size: 28,
            color: saved ? context.colorScheme.primary : null,
          ),
        ),
      ],
    );
  }

  Container _buildKey(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(1),
          width: 1.2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Text(
        widget.song.key ?? '',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: context.colorScheme.secondary),
      ),
    );
  }

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: context.colorScheme.outline,
      ),
    );
  }
}
