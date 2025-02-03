import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/section_data_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/chords_for_key_helper.dart';

class ChordToolbar extends ConsumerWidget {
  final SectionData? sectionData;
  final double bottomPadding;
  final void Function(String chord, SectionData section) onChordSelected;

  const ChordToolbar({
    Key? key,
    required this.sectionData,
    required this.bottomPadding,
    required this.onChordSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(songNotifierProvider).song;
    final songKey =
        song.originalKey ?? const SongKey(chord: ChordsWithoutSharp.C);
    final chords = ChordsForKeyHelper.getDiatonicChordsForKey(songKey);

    if (sectionData == null) return Container();
    return Positioned(
      left: 16,
      right: 16,
      bottom: bottomPadding,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF343536),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF343536),
                Colors.transparent,
                Colors.transparent,
                Color(0xFF343536),
              ],
              stops: const [0.0, 0.05, 0.95, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: chords
                    .map(
                      (chord) => _buildChordButton(
                        context,
                        chord,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChordButton(
    BuildContext context,
    String chord,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF6E6F70),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        onPressed: () => onChordSelected('[$chord]', sectionData!),
        child: Text(chord),
      ),
    );
  }
}
