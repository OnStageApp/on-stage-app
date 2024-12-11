import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/section_data_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/add_song_second_step_content.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/choose_structure_to_add_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_content_view.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/custom_text_widget.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class SongEditorWidget extends ConsumerStatefulWidget {
  const SongEditorWidget({
    super.key,
  });

  @override
  _SongEditorWidgetState createState() => _SongEditorWidgetState();
}

class _SongEditorWidgetState extends ConsumerState<SongEditorWidget> {
  List<SectionData> _sections = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSections();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSections();
  }

  @override
  void dispose() {
    for (final section in _sections) {
      section.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenForTabsChange();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: _sections.isEmpty
          ? _buildEmptySections()
          : ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: _sections.length + 1,
              itemBuilder: (context, index) {
                if (index == _sections.length) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 160),
                        child: EventActionButton(
                          onTap: _addNewSection,
                          text: 'Add New Section',
                          icon: Icons.add,
                        ),
                      ),
                    ],
                  );
                }
                final section = _sections[index];
                return _buildSongContentView(context, section, index);
              },
            ),
    );
  }

  void _initializeSections() {
    final song = ref.watch(songNotifierProvider).song;
    final rawSections = song.rawSections ?? [];

    if (_sections.isEmpty || _sections.length != rawSections.length) {
      setState(() {
        for (final section in _sections) {
          section.controller.dispose();
        }

        _sections = rawSections
            .map(
              (rawSection) => SectionData(
                rawSection: rawSection,
                controller:
                    CustomTextEditingController(text: rawSection.content),
              ),
            )
            .toList();
      });
    }
  }

  Future<void> _addNewSection() async {
    final addedStructureItem = await ChooseStructureToAddModal.show(
      context: context,
      ref: ref,
    );

    if (addedStructureItem != null) {
      setState(() {
        _sections.add(
          SectionData(
            rawSection: RawSection(
              structureItem: addedStructureItem,
              content: '',
            ),
            controller: CustomTextEditingController(text: ''),
          ),
        );
      });
      logger.i('New section added successfully. '
          'Total sections: ${_sections.length}');
    } else {
      logger.d('No structure item selected, modal dismissed');
    }
  }

  void _updateSong() {
    logger.d('Updating song with ${_sections.length} sections');
    final rawSections = _sections
        .map(
          (section) => RawSection(
            structureItem: section.rawSection.structureItem,
            content: section.controller.text,
          ),
        )
        .toList();

    final song = SongModelV2(
      rawSections: rawSections,
    );

    ref.read(songNotifierProvider.notifier).updateSongLocalCache(song);
    logger.i('Song updated successfully in local cache');
  }

  void _listenForTabsChange() {
    ref.listen<int>(tabIndexProvider, (previousIndex, newIndex) {
      if (newIndex == 1) {
        logger.d('Dismissing keyboard and updating song');
        FocusScope.of(context).unfocus();
        _updateSong();
      }
    });
  }

  Widget _buildSongContentView(
    BuildContext context,
    SectionData sectionData,
    int index,
  ) {
    return SongContentView(
      color: sectionData.rawSection.structureItem!.color,
      shortName: sectionData.rawSection.structureItem!.shortName,
      name: sectionData.rawSection.structureItem!.name,
      onDelete: () {
        try {
          logger.d('Deleting section at index $index');
          setState(() {
            final controller = _sections[index].controller;
            _sections.removeAt(index);
            controller.dispose();
          });
          logger.i('Section deleted successfully. '
              'Remaining sections: ${_sections.length}');
        } catch (e, stackTrace) {
          logger.e('Error deleting section', e, stackTrace);
        }
      },
      controller: sectionData.controller,
    );
  }

  Widget _buildEmptySections() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 64),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'No sections added yet, ',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.surfaceDim,
                ),
              ),
              TextSpan(
                text: 'add one.',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()..onTap = _addNewSection,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
