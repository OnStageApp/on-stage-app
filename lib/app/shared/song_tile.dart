import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
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
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

          child: Padding(
            padding: const EdgeInsets.only(left: 5, top: 5, right: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.song.title ?? '',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                      const SizedBox(height: Insets.smaller),
                      Row(
                        children: [
                          Text(
                            'widget.song.artist' ?? '',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Color(0xFF7F818B)),
                          ),
                          // _buildCircle(context),
                          const SizedBox(
                            width: 8,
                          ),
                          _buildKey(context),
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
    );
  }

  Container _buildKey(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
        // border: Border.all(
        //   color: context.colorScheme.secondary.withOpacity(1),
        //   width: 1.2,
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          widget.song.key ?? '',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: const Color(0xFF7F818B)),
        ),
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
