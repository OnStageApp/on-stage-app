import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongNotifier extends _$SongNotifier {
  late final SongRepository _songRepository;

  bool isChorus = false;

  @override
  SongState build() {
    final dio = ref.read(dioProvider);
    _songRepository = SongRepository(dio);
    return const SongState();
  }

  Future<void> init(String songId) async {
    if (songId.isNullEmptyOrWhitespace) {
      return;
    }
    state = state.copyWith(isLoading: true);
    final song = await _songRepository.getSong(songId: songId);
    state = state.copyWith(song: song, isLoading: false);
    logger.i('init song with title: ${state.song.title}');
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
    final currentTonality = state.song.songKey;
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
        //TODO: This has to be changeed using a song configuration
        // songKey: newTonality,
        );

    state = state.copyWith(
      transposeIncrement: difference,
      song: newSong,
    );
  }

  void selectSection(StructureItem item) {
    state = state.copyWith(selectedSectionIndex: item);
  }

  String getKeyName() {
    return state.song.songKey?.name ?? 'Default Key';
    // ${state.song.songKey?.chord?.name ?? ''}'
    // '${_getSharp()} ${_getMajorMinor()}';
  }

  String _getMajorMinor() {
    return state.song.songKey?.isMajor ?? false ? 'Major' : 'Minor';
  }

  String _getSharp() {
    return state.song.songKey?.isSharp ?? false ? '#' : '';
  }
}
