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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSectionsFromSong();
  }

  @override
  Widget build(BuildContext context) {
    _listenForTabsChange();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: _sections.isEmpty
          ? _buildEmptySections()
          : ListView.builder(
              itemCount: _sections.length + 1,
              itemBuilder: (context, index) {
                if (index == _sections.length) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 80),
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

  void _listenForTabsChange() {
    ref.listen<int>(tabIndexProvider, (previousIndex, newIndex) {
      if (previousIndex == 0 && newIndex == 1) {
        _updateSong();
      }
    });
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
        const SizedBox(height: 16)
      ],
    );
  }

  Widget _buildSongContentView(
    BuildContext context,
    SectionData section,
    int index,
  ) {
    return SongContentView(
      color: section.rawSection.structureItem!.color,
      shortName: section.rawSection.structureItem!.shortName,
      name: section.rawSection.structureItem!.name,
      onDelete: () {
        setState(() {
          _sections.removeAt(index);
        });
        _updateSong();
      },
      controller: section.controller,
    );
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
          ),
        );
      });
      _updateSong();
    }
  }

  void _updateSectionsFromSong() {
    final song = ref.watch(songNotifierProvider).song;
    final rawSections = song.rawSections ?? [];
    setState(() {
      _sections = rawSections
          .map(
            (rawSection) => SectionData(
              rawSection: rawSection,
              controller: CustomTextEditingController(text: rawSection.content),
            ),
          )
          .toList();
    });
  }

  void _updateSong() {
    final rawSections = _sections
        .map(
          (section) => RawSection(
            structureItem: section.rawSection.structureItem,
            content: section.controller.text,
          ),
        )
        .toList();
    SongModelV2 song;
    song = _getSongChangesBasedOnIsCreatingOrEditing(rawSections);

    ref.read(songNotifierProvider.notifier).updateSong(song);
  }

  SongModelV2 _getSongChangesBasedOnIsCreatingOrEditing(
    List<RawSection> rawSections,
  ) {
    SongModelV2 song;
    if (ref.watch(songNotifierProvider).song.id == null) {
      song = SongModelV2(
        rawSections: rawSections,
        structure: rawSections
            .map((e) => e.structureItem ?? StructureItem.none)
            .toList(),
      );
    } else {
      song = SongModelV2(
        rawSections: rawSections,
        structure: ref.watch(songNotifierProvider).song.structure,
      );
    }
    return song;
  }
}
