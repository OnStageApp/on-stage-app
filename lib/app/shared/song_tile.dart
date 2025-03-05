import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/songs/song_tab_scope.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/remote_configs/is_beta_team_provider.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongTile extends ConsumerStatefulWidget {
  const SongTile({
    required this.song,
    required this.songTabScope,
    super.key,
  });

  final SongOverview song;
  final SongTabScope songTabScope;

  @override
  ConsumerState<SongTile> createState() => _SongTileState();
}

class _SongTileState extends ConsumerState<SongTile> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.onSurfaceVariant,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          final queryParams = {'songId': widget.song.id};
          context.pushNamed(AppRoute.song.name, queryParameters: queryParams);
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5, top: 5, right: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
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
                            color: context.colorScheme.primary.withAlpha(20),
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Insets.smaller),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${widget.song.artist?.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: const Color(0xFF7F818B)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
              ),
              //TODO: BETA
              if (widget.song.hasFiles && ref.watch(isBetaTeamProvider))
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.songFiles.name,
                      queryParameters: {
                        'songId': widget.song.id,
                      },
                    );
                  },
                  icon: Icon(
                    LucideIcons.paperclip,
                    size: 24,
                    color: context.colorScheme.outline,
                  ),
                ),
              IconButton(
                splashColor: context.colorScheme.surfaceBright,
                onPressed: () {
                  if (widget.song.isFavorite) {
                    ref
                        .read(
                          songsNotifierProvider(widget.songTabScope).notifier,
                        )
                        .removeFavorite(
                          widget.song.id,
                        );
                  } else {
                    ref
                        .read(
                          songsNotifierProvider(widget.songTabScope).notifier,
                        )
                        .addToFavorite(
                          widget.song.id,
                        );
                  }
                },
                icon: Icon(
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
