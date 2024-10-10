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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    final song = ref.read(songNotifierProvider).song;
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
                        margin: const EdgeInsets.only(bottom: 64),
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

  void _updateSong() {
    final rawSections = _sections
        .map(
          (section) => RawSection(
            structureItem: section.rawSection.structureItem,
            content: section.controller.text,
          ),
        )
        .toList();
    final defaultStructure = rawSections.map((e) => e.structureItem!).toList();
    final song = SongModelV2(
      rawSections: rawSections,
      structure: defaultStructure,
    );
    ref.read(songNotifierProvider.notifier).updateSong(song);
  }

  Widget _buildSongContentView(
    BuildContext context,
    SectionData section,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Color(
                      section.rawSection.structureItem!.color,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          section.rawSection.structureItem!.shortName,
                          style: context.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        section.rawSection.structureItem!.name,
                        style: context.textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.shadow,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: context.colorScheme.outline,
                  ),
                  onTap: () {
                    setState(() {
                      _sections.removeAt(index);
                    });
                    _updateSong();
                  },
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: section.controller,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
