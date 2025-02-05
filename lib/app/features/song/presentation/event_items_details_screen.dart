import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/presentation/moment_screen.dart';
import 'package:on_stage_app/app/features/event_items/presentation/widget/moment_settings.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/loading_overlay.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/page_indicator.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';

class EventItemsDetailsScreen extends ConsumerStatefulWidget {
  const EventItemsDetailsScreen({
    required this.eventId,
    required this.fetchEventItems,
    super.key,
  });

  final String eventId;
  final bool fetchEventItems;

  @override
  ConsumerState<EventItemsDetailsScreen> createState() =>
      _EventItemsDetailsScreenState();
}

class _EventItemsDetailsScreenState
    extends ConsumerState<EventItemsDetailsScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = ref.read(eventItemsNotifierProvider).currentIndex;
    _pageController = PageController(initialPage: _currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initEventItems();
    });
  }

  Future<void> _initEventItems() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.fetchEventItems) {
      await ref
          .read(eventItemsNotifierProvider.notifier)
          .getEventItems(widget.eventId);
    }
    await ref
        .read(eventItemsNotifierProvider.notifier)
        .fetchSongForEachEventItem();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isSong(int index) {
    final items = ref.watch(eventItemsNotifierProvider).eventItems;
    return items.isNotEmpty && items[index].song?.id != null;
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);
    final items = eventItemsState.eventItems;

    if (_isLoading || eventItemsState.isLoading) {
      return const LoadingOverlay();
    } else if (items.isEmpty) {
      return const Scaffold(
        appBar: StageAppBar(
          isBackButtonVisible: true,
          title: '',
        ),
        body: Center(
          child: Text('No items added'),
        ),
      );
    }
    final songId = items[_currentIndex].song?.id ?? '';
    final songState = ref.watch(songNotifierProvider(songId));
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: StageAppBar(
          isBackButtonVisible: true,
          title: _isSong(_currentIndex)
              ? songState.song.title ?? ''
              : items[_currentIndex].name ?? '',
          trailing: _isSong(_currentIndex)
              ? SongAppBarLeading(
                  songId: songState.song.id ?? '',
                  isFromEvent: true,
                )
              : MomentSettings(moment: items[_currentIndex]),
          bottom: _isSong(_currentIndex)
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(52),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: EditableStructureList(
                      songId: songState.song.id ?? '',
                    ),
                  ),
                )
              : null,
        ),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Transform.scale(
                    scale: 1,
                    child: _isSong(index)
                        ? SongDetailWidget(
                            songId: items[index].song?.id ?? '',
                            key: ValueKey(
                              '$index - ${items[index].song!.id}',
                            ),
                            widgetPadding: 64,
                            onTapChord: (chord) {},
                          )
                        : MomentScreen(items[index]),
                  ),
                ),
              ),
            ),
            PageIndicator(
              controller: _pageController,
              items: items,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPageChanged(int pageIndex) async {
    setState(() => _currentIndex = pageIndex);
    ref.read(eventItemsNotifierProvider.notifier).setCurrentIndex(pageIndex);
  }
}
