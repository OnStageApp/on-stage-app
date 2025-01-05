import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/shared/scrolling_play_effect.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SongDetailsWithPagesScreen extends ConsumerStatefulWidget {
  const SongDetailsWithPagesScreen({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<SongDetailsWithPagesScreen> createState() =>
      _SongDetailsWithPagesScreenState();
}

class _SongDetailsWithPagesScreenState
    extends ConsumerState<SongDetailsWithPagesScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = ref.read(eventItemsNotifierProvider).currentIndex;
    _pageController = PageController(initialPage: _currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(eventItemsNotifierProvider.notifier)
          .getEventItems(widget.eventId);
      await _initSongAtIndex();
    });
  }

  Future<void> _initSongAtIndex() async {
    if (_isSongItemAtIndex(_currentIndex)) {
      final items = ref.watch(eventItemsNotifierProvider).eventItems;
      final songId = items[_currentIndex].song!.id;
      await ref
          .read(songNotifierProvider.notifier)
          .getSongFromEventItem(songId);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isSongItemAtIndex(int index) {
    final items = ref.watch(eventItemsNotifierProvider).eventItems;
    return items.isNotEmpty && items[index].song?.id != null;
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);
    final items = eventItemsState.eventItems;
    final songState = ref.watch(songNotifierProvider);

    if (songState.isLoading || eventItemsState.isLoading) {
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: StageAppBar(
          isBackButtonVisible: true,
          title: _isSongItemAtIndex(_currentIndex)
              ? songState.song.title ?? ''
              : items[_currentIndex].name ?? '',
          trailing: _isSongItemAtIndex(_currentIndex)
              ? const SongAppBarLeading(isFromEvent: true)
              : null,
          bottom: _isSongItemAtIndex(_currentIndex)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(52),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: EditableStructureList(),
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
                    child: _isSongItemAtIndex(index)
                        ? SongDetailWidget(
                            key: ValueKey('$index - ${items[index].song!.id}'),
                            widgetPadding: 64,
                            onTapChord: (chord) {},
                          )
                        : _MomentPreview(item: items[index]),
                  ),
                ),
              ),
            ),
            _PageIndicator(
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
    await _initSongAtIndex();
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.controller,
    required this.items,
  });

  final PageController controller;
  final List<EventItem> items;

  List<int> _getMomentIndexes() => List.generate(items.length, (i) => i)
      .where((i) => items[i].eventType == EventItemType.other)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SmoothPageIndicator(
              controller: controller,
              count: items.length,
              effect: ScrollingPlayEffect(
                activeDotColor: Colors.blue,
                activeDotScale: 1.2,
                secondColorIndexes: _getMomentIndexes(),
                secondColor: context.colorScheme.onPrimaryFixedVariant,
                dotHeight: 15,
                dotWidth: 15,
                maxVisibleDots: 9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MomentPreview extends StatelessWidget {
  const _MomentPreview({required this.item});

  final EventItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 32, 12, 64),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          item.name ?? '',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: context.colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.backgroundColor,
    this.color,
  });

  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.black.withOpacity(0.3),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: CircularProgressIndicator(
              color: color ?? context.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
