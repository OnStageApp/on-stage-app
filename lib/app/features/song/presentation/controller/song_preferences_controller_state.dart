import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_preferences_controller_state.freezed.dart';

@freezed
class SongPreferencesControllerState with _$SongPreferencesControllerState {
  const factory SongPreferencesControllerState({
    @Default(false) bool isOnAddStructurePage,
  }) = _SongPreferencesControllerState;
}
