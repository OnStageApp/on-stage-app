import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/stage_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongAndAuthorTile extends StatefulWidget {
  const SongAndAuthorTile({
    required this.song,
    super.key,
  });

  final SongModel song;

  @override
  State<SongAndAuthorTile> createState() => _SongAndAuthorTileState();
}

class _SongAndAuthorTileState extends State<SongAndAuthorTile> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return StageTile(
      title: widget.song.title,
      description: widget.song.artist.fullName,
      icon: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: widget.song.artist.imageUrl.isNotNullEmptyOrWhitespace
              ? Image.asset(widget.song.artist.imageUrl!, fit: BoxFit.fill)
              : Text(
                  widget.song.artist.fullName[0],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      trailing: IconButton(
        icon: saved == false
            ? Icon(
                Icons.bookmark_border_rounded,
                color: context.colorScheme.outline,
              )
            : Icon(
                Icons.bookmark_rounded,
                color: context.colorScheme.primary.withOpacity(0.5),
              ),
        onPressed: () {
          setState(() {
            saved = !saved;
          });
        },
      ),
    );
  }
}
