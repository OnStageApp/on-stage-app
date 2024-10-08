import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongDetailsWithPagesScreen extends ConsumerStatefulWidget {
  const SongDetailsWithPagesScreen({
    required this.eventItems,
    super.key,
  });

  final List<EventItem>? eventItems;

  @override
  SongDetailsWithPagesScreenState createState() =>
      SongDetailsWithPagesScreenState();
}

class SongDetailsWithPagesScreenState
    extends ConsumerState<SongDetailsWithPagesScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  var _eventItems = <EventItem>[];

  @override
  void initState() {
    super.initState();
    _eventItems = widget.eventItems ?? [];
    _currentIndex = ref.read(eventItemsNotifierProvider).currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSong(_currentIndex);
    });
  }

  Future<void> _initSong(int index) async {
    final currentSongId = _eventItems[index].song!.id;
    await ref.read(songNotifierProvider.notifier).init(currentSongId);
  }

  bool _isSongNull() =>
      ref.watch(songNotifierProvider).song.id.isNullEmptyOrWhitespace ||
      ref.watch(songNotifierProvider).isLoading ||
      ref.watch(songNotifierProvider).processingSong == true;

  @override
  Widget build(BuildContext context) {
    _eventItems = ref.watch(eventItemsNotifierProvider).songEventItems;
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: StageAppBar(
        background: context.colorScheme.surface,
        isBackButtonVisible: true,
        title: ref.watch(songNotifierProvider).song.title ?? '',
        trailing: const SongAppBarLeading(
          isFromEvent: true,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: EditableStructureList(),
          ),
        ),
      ),
      body: _buildSongsWithPageView(),
    );
  }

  Widget _buildSongsWithPageView() {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _pageController,
      itemCount: _eventItems.length,
      itemBuilder: (context, index) {
        return _buildContent();
      },
      onPageChanged: (int page) async {
        setState(() {
          _currentIndex = page;
        });
        ref.read(eventItemsNotifierProvider.notifier).setCurrentIndex(page);
        await _initSong(page);
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _isSongNull()
            ? const SizedBox()
            : SongDetailWidget(
                widgetPadding: 64,
                onTapChord: () {},
              ),
      ),
    );
  }
}
