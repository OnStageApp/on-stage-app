import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_dark_dropdwon.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_editor_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/song_structure_modal.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddSongSecondStepContent extends ConsumerStatefulWidget {
  const AddSongSecondStepContent({super.key});

  @override
  AddSongSecondStepContentState createState() =>
      AddSongSecondStepContentState();
}

class AddSongSecondStepContentState
    extends ConsumerState<AddSongSecondStepContent>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _lyricsController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _lyricsController = TextEditingController(text: '');
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && mounted) {
        ref.read(tabIndexProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _lyricsController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songTitle = ref.watch(songNotifierProvider).song.title ?? 'Untitled';
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CustomAnimatedTabSwitch(
                  tabController: _tabController,
                  tabs: const ['Preview', 'Edit'],
                  onSwitch: () {
                    final newIndex = _tabController.index == 0 ? 1 : 0;
                    _tabController.animateTo(newIndex);
                  },
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: ContinueButton(
                text: 'Continue',
                onPressed: () {
                  SongStructureModal.show(
                    context: context,
                    ref: ref,
                    onSave: (isOrderPage) {
                      if (isOrderPage) {
                        _reorderStructure();
                      } else {
                        _addNewStructureItems();
                      }
                      ref.read(songNotifierProvider.notifier).saveSongToDB();
                    },
                  );
                },
                isEnabled: true,
                hasShadow: false,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: context.colorScheme.surface,
      appBar: StageAppBar(
        background: context.colorScheme.surface,
        isBackButtonVisible: true,
        title: songTitle,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 80),
      child: TabBarView(
        controller: _tabController,
        children: [
          SongEditorWidget(
            lyricsController: _lyricsController,
          ),
          SongDetailWidget(
            widgetPadding: 64,
            onTapChord: () {},
          ),
        ],
      ),
    );
  }

  void _reorderStructure() {
    final sections = ref.read(songNotifierProvider).sections;
    if (sections.isNotEmpty) {
      final structure = sections.map((e) => e.structure).toList();
      final songWithStructure = SongModelV2(
        structure: structure,
      );
      ref.read(songNotifierProvider.notifier).updateSong(songWithStructure);
    } else {}
  }

  void _addNewStructureItems() {
    final newStructure =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();

    ref.read(songNotifierProvider.notifier).updateStructureOnSong([
      ...?ref.watch(songNotifierProvider).song.structure,
      ...newStructure,
    ]);

    ref.read(songPreferencesControllerProvider.notifier).clearStructureItems();
  }
}

final tabIndexProvider = StateProvider<int>((ref) => 0);
