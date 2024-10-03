import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';

class SongState extends Equatable {
  const SongState({
    this.song = const SongModelV2(),
    this.sections = const [],
    this.isLoading = false,
    this.transposeIncremenet = 0,
    this.document,
    this.selectedSectionIndex,
    this.processingSong = false,
    this.originalSongSections = const [],
  });

  final Content? document;

  final bool isLoading;
  final SongModelV2 song;
  final List<Section> sections;
  final List<Section> originalSongSections;
  final int transposeIncremenet;
  final StructureItem? selectedSectionIndex;
  final bool processingSong;

  @override
  List<Object> get props => [
        song,
        sections,
      ];

  SongState copyWith({
    bool? isLoading,
    bool? processingSong,
    List<Section>? sections,
    SongModelV2? song,
    int? transposeIncrement,
    Content? document,
    StructureItem? selectedSectionIndex,
    List<Section>? originalSongSections,
  }) {
    return SongState(
      song: song ?? this.song,
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      transposeIncremenet: transposeIncrement ?? transposeIncremenet,
      selectedSectionIndex: selectedSectionIndex ?? this.selectedSectionIndex,
      document: document ?? this.document,
      processingSong: processingSong ?? this.processingSong,
      originalSongSections: originalSongSections ?? this.originalSongSections,
    );
  }
}
