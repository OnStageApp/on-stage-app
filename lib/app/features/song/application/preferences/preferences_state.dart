import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';

part 'preferences_state.freezed.dart';

@freezed
class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    @Default(TextSize.medium) TextSize lyricsChordsSize,
    @Default(ChordNotation.american) ChordNotation chordViewMode,
  }) = _PreferencesState;
}
