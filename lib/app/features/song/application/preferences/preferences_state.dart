import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';

part 'preferences_state.freezed.dart';

@freezed
class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    @Default(TextSize.medium) TextSize lyricsChordsSize,
    @Default(SongViewMode.american) SongViewMode chordViewMode,
  }) = _PreferencesState;
}
