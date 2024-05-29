import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongNotifier extends _$SongNotifier {
  bool isChorus = false;

  @override
  SongState build() {
    return const SongState();
  }

  Future<void> init(SongModel song) async {
    if (state.song.id.isNullEmptyOrWhitespace) {
      return;
    }
    state = state.copyWith(song: song);
    logger.i('init songs provider state starting... ${state.song.title}');
  }

  void getSections(List<ChordLyricsLine> lines) {
    final sections = <Section>[];
    var items = <ChordLyricsLine>[];

    var structure = const SongStructure(StructureItem.none, 0);
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].structure.isNotNullEmptyOrWhitespace ||
          i == lines.length - 1) {
        if (items.isNotNullOrEmpty && structure.item != StructureItem.none) {
          sections.add(
            Section(items, structure),
          );
        }
        structure = SongStructure(
          stringToEnum(
            lines[i].structure,
          ),
          i,
        );
        items = [];
      } else {
        items.add(lines[i]);
      }
    }

    state = state.copyWith(
      sections: sections,
    );
  }

  void updateSongSections(List<Section> newSections) {
    state = state.copyWith(sections: newSections);
  }

  void transpose(SongKey newTonality) {
    final currentTonality = state.song.originalKey;
    final currentChord = currentTonality;
    final changedChord = newTonality;
    final currentSemitone = currentTonality!.isSharp ?? false;
    final changedSemitone = newTonality.isSharp ?? false;

    var currentChordValue = currentChord!.chord!.value;
    var changedChordValue = changedChord.chord!.value;

    if (currentSemitone) {
      currentChordValue++;
    }

    if (changedSemitone) {
      changedChordValue++;
    }

    var difference = changedChordValue - currentChordValue;

    if (difference > 6) {
      difference -= 12;
    } else if (difference < -6) {
      difference += 12;
    }

    final newSong = state.song.copyWith(
      songKey: newTonality,
    );

    state = state.copyWith(
      transposeIncrement: difference,
      song: newSong,
    );
  }

  void selectSection(StructureItem item) {
    state = state.copyWith(selectedSectionIndex: item);
  }

  String getKeyName() => '${state.song.songKey?.chord?.name ?? ''}'
      '${_getSharp()} ${_getMajorMinor()}';

  String _getMajorMinor() => state.song.songKey!.isMajor! ? 'Major' : 'Minor';

  String _getSharp() => state.song.songKey!.isSharp! ? '#' : '';
}
