import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';

part 'song_preferences_controller_state.freezed.dart';

@freezed
class SongPreferencesControllerState with _$SongPreferencesControllerState {
  const factory SongPreferencesControllerState({
    @Default(false) bool isOnAddStructurePage,
    @Default([]) List<Section> songSections,
  }) = _SongPreferencesControllerState;
}
