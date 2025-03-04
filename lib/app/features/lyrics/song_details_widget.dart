import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/lyrics/chord_processor.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/song_notes.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/widget_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SongDetailWidget extends ConsumerStatefulWidget {
  const SongDetailWidget({
    required this.songId,
    required this.onTapChord,
    super.key,
    this.scaleFactor = 1.0,
    this.widgetPadding = 0,
    this.lineHeight = 8.0,
    this.horizontalAlignment = CrossAxisAlignment.center,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.leadingWidget,
    this.trailingWidget,
    this.showContentByStructure = true,
    this.useOriginalKeyForRendering = false,
  });

  final bool useOriginalKeyForRendering;
  final String songId;
  final void Function(String chord) onTapChord;

  final int widgetPadding;

  final double lineHeight;

  final Widget? leadingWidget;

  final Widget? trailingWidget;

  final CrossAxisAlignment horizontalAlignment;

  final double scaleFactor;

  final ScrollPhysics scrollPhysics;
  final bool showContentByStructure;

  @override
  SongDetailWidgetState createState() => SongDetailWidgetState();
}

class SongDetailWidgetState extends ConsumerState<SongDetailWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  late TextStyle _textStyle;
  late TextStyle _chordStyle;

  var _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(_getTextStyles);
      await _processTextAndSetSections();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _getTextStyles() {
    _textStyle = WidgetUtils.getLyricsStyle(context).copyWith(
      fontSize:
          ref.watch(userSettingsNotifierProvider).textSize?.size(context) ??
              (TextSize.normal.size(context)),
      color: ref.watch(userSettingsNotifierProvider).songView ==
              SongViewMode.lyrics
          ? context.colorScheme.onSurface
          : context.colorScheme.surfaceDim,
    );
    _chordStyle = WidgetUtils.getChordsStyle(context).copyWith(
      fontSize:
          ref.watch(userSettingsNotifierProvider).textSize?.size(context) ??
              (TextSize.normal.size(context)),
    );
  }

  Future<void> _processTextAndSetSections() async {
    _processText();

    ref.read(songNotifierProvider(widget.songId).notifier).setSections(
          ref.watch(chordProcessorProvider).document,
        );
  }

  void _processText() {
    final originalKey =
        ref.watch(songNotifierProvider(widget.songId)).song.originalKey;
    final key = ref.watch(songNotifierProvider(widget.songId)).song.key;
    final structures = _getStructure();
    ref.read(chordProcessorProvider.notifier).processText(
          rawSections:
              ref.watch(songNotifierProvider(widget.songId)).song.rawSections ??
                  [],
          structures: structures,
          lyricsStyle: _textStyle,
          chordStyle: _chordStyle,
          widgetPadding: widget.widgetPadding,
          scaleFactor: widget.scaleFactor,
          updateSongKey:
              (widget.useOriginalKeyForRendering ? originalKey : key) ??
                  const SongKey(),
          media: MediaQuery.of(context).size.width - 48,
          songViewMode: ref.watch(userSettingsNotifierProvider).songView ??
              SongViewMode.chordLyrics,
          originalSongKey:
              ref.watch(songNotifierProvider(widget.songId)).song.originalKey ??
                  const SongKey(),
        );
  }

  List<StructureItem> _getStructure() {
    List<StructureItem> structures;
    logger.i('showContentByStructure: ${widget.showContentByStructure}');
    if (widget.showContentByStructure) {
      structures =
          ref.watch(songNotifierProvider(widget.songId)).song.structure ?? [];
    } else {
      structures = ref
              .watch(songNotifierProvider(widget.songId))
              .song
              .rawSections
              ?.map((e) => e.structureItem ?? StructureItem.none)
              .toList() ??
          [];
    }
    return structures;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsNotifierProvider);
    final shouldShowDetails = widget.showContentByStructure &&
        ((userSettings.displayMdNotes ?? false) ||
            (userSettings.displaySongDetails ?? false));
    final sections = ref.watch(songNotifierProvider(widget.songId)).sections;
    final chordLyricsDocument = ref.watch(chordProcessorProvider).document;
    _listens();
    if (chordLyricsDocument == null ||
        chordLyricsDocument.sections.isEmpty ||
        _isLoading) {
      return const SizedBox();
    }

    final length = shouldShowDetails ? sections.length + 1 : sections.length;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Dismiss the keyboard when the user starts dragging
        if (scrollInfo is UserScrollNotification &&
            scrollInfo.direction != ScrollDirection.idle) {
          FocusScope.of(context).unfocus();
        }
        return false; // Return false to allow the notification to continue propagating
      },
      child: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: length,
        itemBuilder: (context, index) {
          var sectionIndex = index;
          if (shouldShowDetails) {
            sectionIndex = index - 1;
            if (sectionIndex == -1) {
              return _buildNotesAndInfo();
            }
          }

          return Container(
            margin: EdgeInsets.only(bottom: index == length - 1 ? 64 : 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.colorScheme.onSurfaceVariant,
            ),
            child: _buildLines(sectionIndex, context),
          );
        },
      ),
    );
  }

  List<String>? get currentStagersNames {
    final index = ref.watch(eventItemsNotifierProvider).currentIndex;
    final eventItems = ref.watch(eventItemsNotifierProvider).eventItems;
    final eventItemsLength = eventItems.length;
    if (eventItemsLength == 0) return null;

    return eventItems[index].assignedTo?.map((stager) => stager.name).toList();
  }

  SongNotesCard _buildNotesAndInfo() {
    final song = ref.watch(songNotifierProvider(widget.songId)).song;
    final leads = currentStagersNames;
    return SongNotesCard(
      songId: widget.songId,
      tempo: song.tempo.toString(),
      leads: leads,
      notes: song.songMdNotes,
      onNotesChanged: (String s) {},
    );
  }

  void _listens() {
    ref
      ..listen(userSettingsNotifierProvider, (previous, next) {
        if (previous?.songView != next.songView ||
            previous?.textSize != next.textSize) {
          logger.i('user settings changed');
          setState(_getTextStyles);
          _processTextAndSetSections();
        }
      })
      ..listen(
          songNotifierProvider(widget.songId)
              .select((state) => state.selectedStructureIndex),
          (previous, next) {
        if (next != -1) {
          logger.i('scrolling to index');
          _scrollToIndex();
        }
      })
      ..listen(
        songNotifierProvider(widget.songId),
        (previous, next) {
          if (previous == null) {
            _processTextAndSetSections();

            return;
          }

          final shouldReprocess =
              previous.song.rawSections != next.song.rawSections ||
                  !listEquals(previous.song.structure, next.song.structure) ||
                  previous.song.key != next.song.key;

          if (shouldReprocess) {
            _processTextAndSetSections();
          }
        },
      );
  }

  Future<void> _scrollToIndex() async {
    final indexToScroll =
        ref.read(songNotifierProvider(widget.songId)).selectedStructureIndex;
    final userSettings = ref.watch(userSettingsNotifierProvider);
    final shouldShowDetails = widget.showContentByStructure &&
        ((userSettings.displayMdNotes ?? false) ||
            (userSettings.displaySongDetails ?? false));
    if (indexToScroll == null) return;

    if (_itemScrollController.isAttached) {
      await _itemScrollController.scrollTo(
        index: shouldShowDetails ? indexToScroll + 1 : indexToScroll,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildLines(int index, BuildContext context) {
    final sections = ref.watch(songNotifierProvider(widget.songId)).sections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Color(sections[index].structure.color),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    child: AutoSizeText(
                      sections[index].structure.shortName,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sections[index].structure.name,
                    style: context.textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.shadow,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            if (sections[index].count > 1) ...[
              const SizedBox(width: 6),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(sections[index].structure.color),
                ),
                child: Text(
                  'x${sections[index].count}',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.shadow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(
            height: widget.lineHeight,
          ),
          itemCount: sections[index].lines.length,
          itemBuilder: (context, index2) {
            final line = ref
                .watch(songNotifierProvider(widget.songId))
                .sections[index]
                .lines[index2];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ref.watch(userSettingsNotifierProvider).songView !=
                    SongViewMode.lyrics)
                  _buildChordsLine(line),
                if (line.lyrics.trim().isNotEmpty)

                  /// Only show lyrics if there's actual content
                  RichText(
                    text: TextSpan(
                      text: line.lyrics,
                      style: _textStyle,
                    ),
                    textScaler: TextScaler.linear(widget.scaleFactor),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildChordsLine(SongLines line) {
    return Row(
      children: line.chords
          .map(
            (chord) => Row(
              children: [
                SizedBox(
                  width: chord.leadingSpace,
                ),
                GestureDetector(
                  onTap: () => widget.onTapChord(chord.chordText),
                  child: RichText(
                    text: TextSpan(
                      text: chord.chordText,
                      style: _chordStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  void didUpdateWidget(covariant SongDetailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class TextRender extends CustomPainter {
  TextRender(this.text, this.style);

  final String text;
  final TextStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Section {
  Section(this.lines, this.structure, {this.count = 1});

  final List<SongLines> lines;
  final StructureItem structure;
  final int count;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Section &&
          runtimeType == other.runtimeType &&
          structure.name == other.structure.name;

  @override
  int get hashCode => structure.name.hashCode;
}
