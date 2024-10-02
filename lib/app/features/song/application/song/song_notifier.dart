import 'dart:async';

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
  SongRepository? _songRepository;

  SongRepository get songRepository {
    _songRepository ??= SongRepository(ref.read(dioProvider));
    return _songRepository!;
  }

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
    final song = await songRepository.getSong(songId: songId);
    state = state.copyWith(song: song, isLoading: false);
    logger.i('init song with title: ${state.song.title}');
  }

  void setProcessingSongLoading(bool isLoading) {
    state = state.copyWith(processingSong: isLoading);
  }

  void getSections(List<ChordLyricsLine> lines) {
    final sections = <Section>[];
    var items = <ChordLyricsLine>[];

    var structure = const SongStructure(StructureItem.none, 0);
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].structure.isNotNullEmptyOrWhitespace) {
        if (items.isNotNullOrEmpty && structure.item != StructureItem.none) {
          sections.add(Section(items, structure));
        }
        structure = SongStructure(stringToEnum(lines[i].structure), i);
        items = [];
      }
      items.add(lines[i]);
    }

    if (items.isNotNullOrEmpty && structure.item != StructureItem.none) {
      sections.add(Section(items, structure));
    }

    state = state.copyWith(sections: sections);
  }

  void updateSongSections(List<Section> newSections) {
    state = state.copyWith(sections: newSections);
  }

  void transpose(SongKey newTonality) {
    final currentTonality = state.song.songKey;
    final currentChord = currentTonality;
    final changedChord = newTonality;
    final currentSemitone = currentTonality.isSharp ?? false;
    final changedSemitone = newTonality.isSharp ?? false;

    var currentChordValue = currentChord.chord!.value;
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

  void selectSection(StructureItem? item) {
    state = state.copyWith(selectedSectionIndex: item);
  }
  //
  // Future<void> updateSongStructure() async {
  //   final songConfigRepo = SongConfigRepository(ref.read(dioProvider));
  //   final originalSong = state.song.lyrics;
  //   final sections = state.sections;
  //   final structures = sections.map((e) => e.structure).toList();
  //   final newLyrics = '';
  //
  //   final request = SongConfigRequest(
  //     songId: state.song.id,
  //     teamId: ref.read(teamNotifierProvider).currentTeam?.id,
  //     lyrics: newLyrics,
  //   );
  //   unawaited(songConfigRepo.updateSongConfig(songConfigRequest: request));
  // }

  Future<void> updateSongStructure() async {
    final updatedSong = reorderSections(state.sections, [
      SongStructure(StructureItem.V1, 0),
      SongStructure(StructureItem.V1, 1),
      SongStructure(StructureItem.B, 2)
    ]);

    state = state.copyWith(sections: updatedSong);
    // final songConfigRepo = SongConfigRepository(ref.read(dioProvider));
    // final originalSong = state.song.lyrics;
    // final sections = state.sections;
    //
    // // Create a map of section identifiers to their respective lyrics
    // final sectionLyricsMap = Map.fromEntries(
    //     sections.map((section) => MapEntry(section.structure, section.lyrics)));
    //
    // // Define the new structure (this could be dynamic, passed as a parameter)
    // final updatedStructure = ['C', 'V1', 'C1'];
    //
    // // Reorder the lyrics based on the new structure
    // final newLyrics =
    //     updatedStructure.map((section) => sectionLyricsMap[section]).join('\n');
    //
    // final request = SongConfigRequest(
    //   songId: state.song.id,
    //   teamId: ref.read(teamNotifierProvider).currentTeam?.id,
    //   lyrics: newLyrics,
    // );
    //
    // // Send the updated lyrics to the repository
    // unawaited(songConfigRepo.updateSongConfig(songConfigRequest: request));
  }

  List<Section> reorderSections(
      List<Section> originalSections, List<SongStructure> customSongStructure) {
    // Create a map of StructureItem to Section from the originalSections
    final sectionMap = {
      for (var section in originalSections) section.structure.item: section,
    };

    // Reorder sections based on the customSongStructure
    List<Section> reorderedSections = [];

    for (var customStructure in customSongStructure) {
      final correspondingSection = sectionMap[customStructure.item];
      if (correspondingSection != null) {
        // Add the corresponding section to the reordered list
        reorderedSections.add(correspondingSection);
      }
    }

    return reorderedSections;
  }
}
