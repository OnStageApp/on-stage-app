import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_dark_dropdwon.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_editor_widget.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddSongSecondStepContent extends ConsumerStatefulWidget {
  const AddSongSecondStepContent({
    super.key,
  });

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
      floatingActionButton: _buildFloatingActionButton(context),
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
      child: TabBarView(
        controller: _tabController,
        children: [
          const SongEditorWidget(),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: SongDetailWidget(
              widgetPadding: 64,
              onTapChord: () {},
              showContentByStructure: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
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
                await _onSavedSong(context);
              },
              isEnabled: true,
              hasShadow: false,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSavedSong(BuildContext context) async {
    final song = ref.watch(songNotifierProvider).song;
    final songNotifier = ref.read(songNotifierProvider.notifier);
    if (song.id == null) {
      await songNotifier.saveSongToDB();
    } else {
      await songNotifier.updateSongToDB(SongRequest.fromSongModel(song));
    }
    if (mounted) {
      context.goNamed(
        AppRoute.song.name,
        queryParameters: {'songId': song.id},
      );
    }
  }
}

final tabIndexProvider = StateProvider<int>((ref) => 0);
