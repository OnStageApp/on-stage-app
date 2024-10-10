import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_dark_dropdwon.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_editor_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/song_structure_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

import '../../../../../resources/generated/assets.gen.dart';

class AddSongSecondStepContent extends ConsumerStatefulWidget {
  const AddSongSecondStepContent({super.key});

  @override
  AddSongSecondStepContentState createState() =>
      AddSongSecondStepContentState();
}

class AddSongSecondStepContentState
    extends ConsumerState<AddSongSecondStepContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && mounted) {
        ref.read(tabIndexProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
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
                text: 'Save Song',
                onPressed: () async {
                  await ref.read(songNotifierProvider.notifier).saveSongToDB();
                  final songId = ref.watch(songNotifierProvider).song.id;
                  if (mounted) {
                    context.goNamed(
                      AppRoute.song.name,
                      queryParameters: {'songId': songId},
                    );
                  }
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
          const SongEditorWidget(),
          SongDetailWidget(
            widgetPadding: 64,
            onTapChord: () {},
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     if (ref
          //         .watch(songNotifierProvider)
          //         .song
          //         .structure
          //         .isNotNullOrEmpty)
          //       Row(
          //         children: [
          //           const Expanded(child: EditableStructureList()),
          //           _buildArrowWidget(context),
          //         ],
          //       ),
          //     const SizedBox(height: 16),
          //     Expanded(
          //       child: SongDetailWidget(
          //         widgetPadding: 64,
          //         onTapChord: () {},
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void _reorderStructure() {
    final structure =
        ref.watch(songPreferencesControllerProvider).structureItems;
    ref.watch(songNotifierProvider.notifier).updateStructureOnSong(structure);
  }

  void _addNewStructureItems() {
    final newStructure =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();

    ref.watch(songNotifierProvider.notifier).updateStructureOnSong([
      ...?ref.watch(songNotifierProvider).song.structure,
      ...newStructure,
    ]);

    ref.read(songPreferencesControllerProvider.notifier).clearStructureItems();
  }

  Widget _buildArrowWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        SongStructureModal.show(
          context: context,
          ref: ref,
          onSave: (isOrderPage) {
            if (isOrderPage) {
              _reorderStructure();
              context.popDialog();
            } else {
              _addNewStructureItems();
            }
          },
        );
      },
      child: Ink(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Assets.icons.arrowDown.svg(),
        ),
      ),
    );
  }
}

final tabIndexProvider = StateProvider<int>((ref) => 0);
