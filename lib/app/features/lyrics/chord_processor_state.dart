import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';

class ChordProcessorState extends Equatable {
  const ChordProcessorState({this.document});

  final Content? document;

  @override
  List<Object> get props => [];

  ChordProcessorState copyWith({
    Content? content,
  }) {
    return ChordProcessorState(
      document: content ?? this.document,
    );
  }
}
