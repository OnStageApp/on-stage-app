import 'package:flutter/material.dart';
import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongTile extends StatefulWidget {
  const SongTile({
    required this.song,
    super.key,
  });

  final SongOverview song;

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoute.song.name, extra: SongDummy.playlist.first);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5, top: 5, right: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.title ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: Insets.smaller),
                    Row(
                      children: [
                        Text(
                          '${widget.song.artist}' ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: const Color(0xFF7F818B)),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SongKeyLabelWidget(songKey: widget.song.key ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    saved = !saved;
                  });
                },
                child: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  size: 28,
                  color:
                      saved ? const Color(0xFFF25454) : const Color(0xFF74777F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
