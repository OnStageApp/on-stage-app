import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SongState extends Equatable {
  const SongState({
    this.song = const SongModel(),
    this.sections = const [],
    this.isLoading = false,
    this.transposeIncremenet = 0,
    this.document,
    this.selectedSectionIndex,
  });

  final ChordLyricsDocument? document;

  final bool isLoading;
  final SongModel song;
  final List<Section> sections;
  final int transposeIncremenet;
  final StructureItem? selectedSectionIndex;

  @override
  List<Object> get props => [
        song,
        sections,
      ];

  SongState copyWith({
    bool? isLoading,
    List<Section>? sections,
    SongModel? song,
    int? transposeIncrement,
    ChordLyricsDocument? document,
    StructureItem? selectedSectionIndex,
  }) {
    return SongState(
      song: song ?? this.song,
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      transposeIncremenet: transposeIncrement ?? this.transposeIncremenet,
      selectedSectionIndex: selectedSectionIndex ?? this.selectedSectionIndex,
      document: document ?? this.document,
    );
  }
}
