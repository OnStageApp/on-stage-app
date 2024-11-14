import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongTile extends ConsumerStatefulWidget {
  const SongTile({
    required this.song,
    super.key,
  });

  final SongOverview song;

  @override
  ConsumerState<SongTile> createState() => _SongTileState();
}

class _SongTileState extends ConsumerState<SongTile> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final queryParams = {'songId': widget.song.id};
        context.pushNamed(AppRoute.song.name, queryParameters: queryParams);
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
                    if (widget.song.teamId.isNotNullEmptyOrWhitespace)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Team's Song"),
                      ),
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
                          '${widget.song.artist?.name}' ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: const Color(0xFF7F818B)),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SongKeyLabelWidget(
                          songKey: widget.song.key?.name ?? '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.song.isFavorite) {
                    ref.read(songsNotifierProvider.notifier).removeFavorite(
                          widget.song.id,
                        );
                  } else {
                    ref.read(songsNotifierProvider.notifier).addToFavorite(
                          widget.song.id,
                        );
                  }
                },
                child: Icon(
                  widget.song.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 24,
                  color: widget.song.isFavorite
                      ? const Color(0xFFF25454)
                      : const Color(0xFF74777F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
