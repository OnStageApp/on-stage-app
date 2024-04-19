import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_preferences_controller.g.dart';

@Riverpod()
class SongPreferencesController extends _$SongPreferencesController {
  @override
  SongPreferencesControllerState build() {
    return const SongPreferencesControllerState();
  }

  void toggleAddStructurePage({required bool isOnAddStructurePage}) {
    state = state.copyWith(isOnAddStructurePage: isOnAddStructurePage);
  }
}
