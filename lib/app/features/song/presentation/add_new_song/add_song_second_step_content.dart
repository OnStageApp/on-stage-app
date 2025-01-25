import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_dark_dropdwon.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song_editor/song_editor_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/song_editor_widget.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;
  double _bottomInsets = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songEditorNotifierProvider.notifier).init();
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    setState(() {
      _bottomInsets = bottomInset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final songTitle = ref.watch(songNotifierProvider).song.title ?? 'Untitled';
    final isLargeScreen = context.isLargeScreen;

    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: songTitle,
        onBackButtonPressed: _handleBackPress,
        trailing: isLargeScreen ? _buildTrailingButton(context) : null,
      ),
      body: isLargeScreen
          ? EditorTabSwitch(tabController: _tabController)
          : Stack(
              children: [
                EditorTabSwitch(tabController: _tabController),
                Positioned(
                  bottom: -_bottomInsets,
                  left: 0,
                  right: 0,
                  child: _buildFloatingActionButton(context),
                ),
              ],
            ),
    );
  }

  void _handleBackPress() {
    final songId = ref.watch(songNotifierProvider).song.id;
    if (songId == null) {
      context.goNamed(AppRoute.home.name);
      return;
    }
    ref.read(songNotifierProvider.notifier).getSongById(songId);
    context.pop();
  }

  Widget _buildTrailingButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                height: 42,
                width: 100,
                child: CustomAnimatedTabSwitch(
                  tabController: _tabController,
                  tabs: const ['Preview', 'Edit'],
                  onSwitch: _handleTabSwitch,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              height: 42,
              width: 150,
              child: ContinueButton(
                hasShadow: false,
                text: _isSaving ? 'Saving...' : 'Save Song',
                onPressed: _isSaving ? () {} : () => _onSavedSong(context),
                isEnabled: !_isSaving,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CustomAnimatedTabSwitch(
                tabController: _tabController,
                tabs: const ['Preview', 'Edit'],
                onSwitch: _handleTabSwitch,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: ContinueButton(
              hasShadow: false,
              text: _isSaving ? 'Saving...' : 'Save Song',
              onPressed: _isSaving ? () {} : () => _onSavedSong(context),
              isEnabled: !_isSaving,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabSwitch() {
    final newIndex = _tabController.index == 0 ? 1 : 0;
    if (newIndex == 1) {
      FocusScope.of(context).unfocus();
      ref.read(songEditorNotifierProvider.notifier).updateSong();
    }
    _tabController.animateTo(newIndex);
  }

  Future<void> _onSavedSong(BuildContext context) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      ref.read(songEditorNotifierProvider.notifier).updateSong();
      final song = ref.watch(songNotifierProvider).song;
      final songNotifier = ref.read(songNotifierProvider.notifier);

      if (song.id == null) {
        songNotifier.setDefaultStructureLocally(song.availableStructureItems);
      }

      final success = song.id == null
          ? await songNotifier.saveSongToDB()
          : await songNotifier.updateSongToDB(SongRequest.fromSongModel(song));

      if (!mounted) return;

      if (!success) {
        TopFlushBar.show(
          context,
          'Error saving song, something went wrong.',
          isError: true,
        );
        return;
      }

      if (song.id == null) {
        return;
      }

      context.goNamed(
        AppRoute.song.name,
        queryParameters: {'songId': song.id},
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class EditorTabSwitch extends ConsumerWidget {
  const EditorTabSwitch({
    required this.tabController,
    super.key,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const SongEditorWidget(),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: SongDetailWidget(
              widgetPadding: 64,
              onTapChord: (chord) {},
              showContentByStructure: false,
            ),
          ),
        ],
      ),
    );
  }
}
