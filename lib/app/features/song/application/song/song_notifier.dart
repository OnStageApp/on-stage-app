import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongNotifier extends _$SongNotifier {
  SongRepository? _songRepository;

  SongRepository get songRepository {
    _songRepository ??= SongRepository(ref.watch(dioProvider));
    return _songRepository!;
  }

  bool isChorus = false;

  @override
  SongState build() {
    final dio = ref.watch(dioProvider);
    _songRepository = SongRepository(dio);
    return const SongState();
  }

  Future<void> init(String songId) async {
    if (songId.isNullEmptyOrWhitespace) {
      return;
    }
    state = state.copyWith(isLoading: true);
    final song = await songRepository.getSong(songId: songId);

    state = state.copyWith(
      song: song,
      isLoading: false,
    );
    logger.i('init song with title: ${state.song.title}');
  }

  void resetState() {
    state = const SongState();
  }

  void setProcessingSongLoading(bool isLoading) {
    state = state.copyWith(processingSong: isLoading);
  }

  void setSections(Content? document) {
    state = state.copyWith(
      sections: document?.sections,
      originalSongSections: document?.originalSections,
    );
  }

  List<StructureItem> getOriginalStructure() {
    return state.originalSongSections.map((e) => e.structure).toList();
  }

  void updateSongSections(List<Section> newSections) {
    state = state.copyWith(sections: newSections);
  }

  void setDefaultStructureLocally(List<StructureItem> structureItems) {
    state = state.copyWith(
      song: state.song.copyWith(structure: structureItems),
    );
  }

  void updateStructureOnSong(List<StructureItem> structureItems) {
    state = state.copyWith(
      song: state.song.copyWith(structure: structureItems),
    );

    if (state.song.teamId == null) {
      _updateSongConfig();
    } else {
      updateSongToDB(
        SongRequest(
          structure: structureItems,
        ),
      );
    }

    logger.i('updated song with structure: ${state.song.structure}');
  }

  void _updateSongConfig() {
    final songId = state.song.id;
    final teamId = ref.read(teamNotifierProvider).currentTeam?.id;
    ref
        .read(songConfigurationNotifierProvider.notifier)
        .updateSongConfiguration(
          SongConfigRequest(
            songId: songId,
            teamId: teamId,
            isCustom: true,
            structure: state.song.structure,
          ),
        );
  }

  void updateSongLocalCache(SongModelV2 newSong) {
    final updatedStructure = _getModifiedStructure(newSong);

    final updatedSong = state.song.copyWith(
      title: newSong.title ?? state.song.title,
      key: newSong.key ?? state.song.key,
      originalKey: newSong.originalKey ?? state.song.originalKey,
      tempo: newSong.tempo ?? state.song.tempo,
      artist: newSong.artist ?? state.song.artist,
      rawSections: newSong.rawSections ?? state.song.rawSections,
      theme: newSong.theme ?? state.song.theme,
      structure: updatedStructure,
    );

    state = state.copyWith(song: updatedSong);

    logger.i('updated song in notifier with title: ${state.song.title}');
  }

  List<StructureItem> _getModifiedStructure(SongModelV2 newSong) {
    final rawSections = newSong.rawSections;
    final currentStructure = state.song.structure ?? [];

    /// If no raw sections, return current structure
    if (rawSections == null || rawSections.isEmpty) {
      return currentStructure;
    }

    /// Get all non-null structure items from new sections
    final newSectionItems = rawSections
        .map((e) => e.structureItem)
        .whereType<StructureItem>()
        .toSet();

    /// For existing songs, handle structure changes
    if (state.song.id != null) {
      final currentItems = currentStructure.toSet();

      /// Find added and removed items
      final addedItems = newSectionItems.difference(currentItems);
      final removedItems = currentItems.difference(newSectionItems);

      /// Update structure: keep existing items, add new ones, remove deleted ones
      return [
        ...currentStructure.where((item) => !removedItems.contains(item)),
        ...addedItems,
      ];
    }

    /// For new songs, only keep structure items that exist in sections
    return currentStructure.where(newSectionItems.contains).toList();
  }

  void updateSongSectionsWithNewStructureItems(
    List<StructureItem> structureItems,
  ) {
    final newSections = _createSectionBasedOnNewStructureItems(structureItems);
    final allSections = state.sections;
    final updatedSections = [...allSections, ...newSections];
    updateSongSections(updatedSections);
  }

  List<Section> _createSectionBasedOnNewStructureItems(
    List<StructureItem> structureItems,
  ) {
    final newSections = <Section>[];
    for (final item in structureItems) {
      final section = state.originalSongSections
          .firstWhere((element) => element.structure == item);
      newSections.add(section);
    }
    return newSections;
  }

  void transpose(SongKey newTonality) {
    final updatedSong = state.song.copyWith(
      key: newTonality,
    );
    state = state.copyWith(
      song: updatedSong,
    );
  }

  void selectSection(int item) {
    state = state.copyWith(selectedStructureItem: -1);
    state = state.copyWith(selectedStructureItem: item);
  }

  Future<void> saveSongToDB() async {
    final songRequestModel = SongRequest.fromSongModel(state.song);
    final savedSong = await songRepository.addSong(song: songRequestModel);
    state = state.copyWith(
      song: savedSong,
    );
  }

  Future<void> updateSongToDB(SongRequest songRequest) async {
    final songRequestModel = songRequest;
    final savedSong = await songRepository.updateSong(
      song: songRequestModel,
      id: state.song.id!,
    );
    state = state.copyWith(
      song: savedSong,
    );
  }
}
