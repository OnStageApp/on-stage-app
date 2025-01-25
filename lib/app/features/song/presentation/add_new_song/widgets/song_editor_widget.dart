import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song_editor/song_editor_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/section_data_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/choose_structure_to_add_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/chords_for_key_helper.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_content_view.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/custom_text_widget.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class SongEditorWidget extends ConsumerStatefulWidget {
  const SongEditorWidget({Key? key}) : super(key: key);

  @override
  _SongEditorWidgetState createState() => _SongEditorWidgetState();
}

class _SongEditorWidgetState extends ConsumerState<SongEditorWidget> {
  SectionData? _focusedSection;

  @override
  void initState() {
    logger.d('Initializing SongEditorWidget');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger.d('Running post-frame callback to initialize sections');
      _initializeSections();
    });
    super.initState();
  }

  void _initializeSections() {
    logger.d('Starting sections initialization');
    final song = ref.watch(songNotifierProvider).song;
    final rawSections = song.rawSections ?? [];

    final sections = rawSections.map((rawSection) {
      // final focusNode = FocusNode();
      final section = SectionData(
        rawSection: rawSection,
        // focusNode: focusNode,
        controller: CustomTextEditingController(text: rawSection.content),
      );

      // focusNode.addListener(() {
      //   print('here');
      //   if (focusNode.hasFocus) {
      //     logger.i(
      //         'Focus gained for section ${section.rawSection.structureItem?.name}');
      //     setState(() {
      //       _focusedSection = section;
      //     });
      //   }
      // });

      return section;
    }).toList();

    ref.read(songEditorNotifierProvider.notifier).setSections(sections);
    logger.i('Successfully initialized ${sections.length} sections');
  }

  Future<void> _addNewSection() async {
    logger.d('Opening structure selection modal');
    try {
      final addedStructureItems = await ChooseStructureToAddModal.show(
        context: context,
        ref: ref,
      );

      if (addedStructureItems != null && addedStructureItems.isNotEmpty) {
        logger.d(
          'Selected structures: ${addedStructureItems.map((item) => item.name).join(", ")}',
        );

        for (final structureItem in addedStructureItems) {
          final newSection = SectionData(
            rawSection: RawSection(
              structureItem: structureItem,
              content: '',
            ),
            // focusNode: FocusNode(),
            controller: CustomTextEditingController(text: ''),
          );

          ref.read(songEditorNotifierProvider.notifier).addSection(newSection);
        }
      } else {
        logger.d('Structure selection cancelled');
      }
    } catch (e) {
      logger.e('Error adding new section');
    }
  }

  /// Builds a single section view.
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
        logger.d(
          'Delete requested for section '
          '${sectionData.rawSection.structureItem?.name} at index $index',
        );
        try {
          ref.read(songEditorNotifierProvider.notifier).removeSection(index);
        } catch (e, stackTrace) {
          logger.e('Error deleting section at index $index', e, stackTrace);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error deleting section')),
            );
          }
        }
      },
      controller: sectionData.controller,
      // focusNode: sectionData.focusNode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = ref.watch(songEditorNotifierProvider);
    logger.d('Building SongEditorWidget with ${sections.length} sections');
    final bottomInsets = View.of(context).viewInsets.bottom;
    print('Bottom insets: $bottomInsets');
    // if (context.isLargeScreen) {
    //   return Stack(
    //     children: [
    //       _buildBody(sections),
    //       if (sections.isNotEmpty)
    //         ChordToolbar(
    //           sectionData: _focusedSection,
    //           bottomPadding: bottomInsets > 120 ? 32 : 32,
    //           onChordSelected: _insertChord,
    //         ),
    //     ],
    //   );
    // } else {
    // return KeyboardActions(
    // config: _buildKeyboardActionsConfig(context, sections),
    // disableScroll: true,
    // autoScroll: false,
    return _buildBody(sections);
    // );
    // }
  }

  Widget _buildBody(List<SectionData> sections) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: sections.isEmpty
          ? _buildEmptySections()
          : SizedBox(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                itemCount: sections.length + 1,
                itemBuilder: (context, index) {
                  if (index == sections.length) {
                    return _buildAddButton();
                  }
                  final section = sections[index];
                  return _buildSongContentView(context, section, index);
                },
              ),
            ),
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
                text: 'No sections added, ',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.surfaceDim,
                ),
              ),
              TextSpan(
                text: 'add sections',
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

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 400),
      child: EventActionButton(
        onTap: _addNewSection,
        text: 'Add New Sections',
        icon: Icons.add,
      ),
    );
  }

  // KeyboardActionsConfig _buildKeyboardActionsConfig(
  //   BuildContext context,
  //   List<SectionData> sections,
  // ) {
  //   return KeyboardActionsConfig(
  //     keyboardBarColor: const Color(0xFF343536),
  //     nextFocus: false,
  //     actions: sections.map((section) {
  //       return KeyboardActionsItem(
  //         displayArrows: false,
  //         focusNode: section.focusNode,
  //         toolbarButtons: [
  //           (node) => _buildChordToolbar(section),
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildChordToolbar(SectionData sectionData) {
    final song = ref.watch(songNotifierProvider).song;
    final songKey = song.key ?? const SongKey(chord: ChordsWithoutSharp.C);
    final chords = ChordsForKeyHelper.getDiatonicChordsForKey(songKey);

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: chords
            .map((chord) => _buildChordButton(chord, sectionData))
            .toList(),
      ),
    );
  }

  Widget _buildChordButton(String chord, SectionData sectionData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF6E6F70),
          foregroundColor: Colors.white,
          textStyle: context.textTheme.titleMedium,
        ),
        onPressed: () {
          _insertChord('[$chord]', sectionData);
        },
        child: Text(chord),
      ),
    );
  }

  /// Inserts the chord at the current cursor position (or replaces selection)
  /// within the given section's controller.
  void _insertChord(String chord, SectionData sectionData) {
    final controller = sectionData.controller;
    final selection = controller.selection;

    if (selection.start < 0 || selection.end < 0) return;

    final oldText = controller.text;
    final newText = oldText.replaceRange(
      selection.start,
      selection.end,
      chord,
    );

    final newSelectionIndex = selection.start + chord.length;

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
