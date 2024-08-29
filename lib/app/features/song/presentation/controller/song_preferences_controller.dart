import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_preferences_controller.g.dart';

@Riverpod(keepAlive: true)
class SongPreferencesController extends _$SongPreferencesController {
  @override
  SongPreferencesControllerState build() {
    return const SongPreferencesControllerState();
  }

  void toggleAddStructurePage({required bool isOnAddStructurePage}) {
    state = state.copyWith(isOnAddStructurePage: isOnAddStructurePage);
  }

  void addSongSection(Section section) {
    final sections = List<Section>.from(state.songSections);

    sections.add(section);
    state = state.copyWith(songSections: sections);
  }

  void resetSongSections() {
    state = state.copyWith(songSections: []);
  }

  void removeSongSection(Section section) {
    final sections = List<Section>.from(state.songSections);
    sections.remove(section);
    state = state.copyWith(songSections: sections);
  }
}
