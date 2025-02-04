import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferencesTempo extends ConsumerWidget {
  const PreferencesTempo({required this.songId, super.key});

  final String songId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tempo',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: Insets.small),
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${ref.watch(songNotifierProvider(songId)).song.tempo} BPM',
              style: context.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
