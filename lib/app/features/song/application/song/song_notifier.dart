import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
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

  void updateStructureOnSong(List<StructureItem> structureItems) {
    state = state.copyWith(
      song: state.song.copyWith(structure: structureItems),
    );
    logger.i('updated song with structure: ${state.song.structure}');
  }

  void updateSong(SongModelV2 newSong) {
    final updatedSong = state.song.copyWith(
      title: newSong.title ?? state.song.title,
      key: newSong.key ?? state.song.key,
      originalKey: newSong.originalKey ?? state.song.originalKey,
      tempo: newSong.tempo ?? state.song.tempo,
      artist: newSong.artist ?? state.song.artist,
      rawSections: newSong.rawSections ?? state.song.rawSections,
      structure: newSong.structure ?? state.song.structure,
    );
    state = state.copyWith(song: updatedSong);
    logger.i('updated song');
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

  void selectSection(StructureItem item) {
    state = state.copyWith(selectedStructureItem: item);
  }

  Future<void> saveSongToDB() async {
    final songRequestModel = SongRequest.fromSongModel(state.song);
    final savedSong = await songRepository.addSong(song: songRequestModel);
    state = state.copyWith(
      song: savedSong,
    );
  }
}
