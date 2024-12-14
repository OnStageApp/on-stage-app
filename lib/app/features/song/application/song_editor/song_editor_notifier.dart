import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/section_data_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_editor_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongEditorNotifier extends _$SongEditorNotifier {
  @override
  List<SectionData> build() {
    logger.d('Initializing SongEditorNotifier with empty sections');
    return [];
  }

  void init() {
    logger.d('Initializing SongEditorNotifier');
    state = [];
  }

  void setSections(List<SectionData> sections) {
    logger.d('Setting sections: count=${sections.length}');
    try {
      state = sections;
      logger.i('Successfully set ${sections.length} sections');
    } catch (e, stack) {
      logger.e('Error setting sections', e, stack);
    }
  }

  void addSection(SectionData section) {
    logger.d('Adding new section: ${section.rawSection.structureItem?.name}');
    try {
      final newSections = [...state, section];
      state = newSections;
      logger.i('Successfully added section. Total sections: ${state.length}');

      logger.d('Updating song after adding section');
      updateSong();
    } catch (e, stack) {
      logger.e('Error adding section', e, stack);
    }
  }

  void removeSection(int index) {
    logger.d('Attempting to remove section at index $index');

    if (index < 0 || index >= state.length) {
      logger
          .w('Invalid section index: $index (total sections: ${state.length})');
      return;
    }

    try {
      final newSections = [...state];
      final removedSection = newSections.removeAt(index);
      logger.d(
        'Removed section: ${removedSection.rawSection.structureItem?.name}',
      );

      removedSection.controller.dispose();
      logger.d('Disposed controller for removed section');

      state = newSections;
      logger.i(
        'Successfully removed section. Remaining sections: ${state.length}',
      );

      updateSong();
    } catch (e, stack) {
      logger.e('Error removing section at index $index', e, stack);
    }
  }

  void updateSong() {
    logger.d('Starting song update with ${state.length} sections');
    try {
      final rawSections = state
          .map(
            (section) => RawSection(
              structureItem: section.rawSection.structureItem,
              content: section.controller.text,
            ),
          )
          .toList();

      final song = SongModelV2(rawSections: rawSections);
      ref.read(songNotifierProvider.notifier).updateSongLocalCache(song);

      logger.i('Successfully updated song with ${rawSections.length} sections');
    } catch (e, stack) {
      logger.e('Error updating song', e, stack);
    }
  }
}
