import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';

class ChordProcessorState extends Equatable {
  const ChordProcessorState({this.document});

  final ChordLyricsDocument? document;

  @override
  List<Object> get props => [];

  ChordProcessorState copyWith({
    ChordLyricsDocument? document,
  }) {
    return ChordProcessorState(
      document: document ?? this.document,
    );
  }
}
