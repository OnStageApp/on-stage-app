import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song_editor/song_editor_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/section_data_model.dart';
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
    final sections = rawSections
        .map(
          (rawSection) => SectionData(
            rawSection: rawSection,
            controller: CustomTextEditingController(text: rawSection.content),
          ),
        )
        .toList();

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
            'Selected structures: ${addedStructureItems.map((item) => item.name).join(", ")}');

        for (final structureItem in addedStructureItems) {
          final newSection = SectionData(
            rawSection: RawSection(
              structureItem: structureItem,
              content: '',
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = ref.watch(songEditorNotifierProvider);
    logger.d('Building SongEditorWidget with ${sections.length} sections');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: sections.isEmpty
          ? _buildEmptySections()
          : ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: sections.length + 1,
              itemBuilder: (context, index) {
                if (index == sections.length) {
                  return _buildAddButton();
                }
                final section = sections[index];
                return _buildSongContentView(context, section, index);
              },
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 160),
          child: EventActionButton(
            onTap: _addNewSection,
            text: 'Add New Sections',
            icon: Icons.add,
          ),
        ),
      ],
    );
  }
}
