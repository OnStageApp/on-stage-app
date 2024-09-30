import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/chord_processor.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/enums/text_size.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/widget_utils.dart';

class SongDetailWidget extends ConsumerStatefulWidget {
  const SongDetailWidget({
    // required this.lyrics,
    // required this.textStyle,
    // required this.chordStyle,
    // required this.structureStyle,
    required this.onTapChord,
    // required this.chorusStyle,
    super.key,
    // this.capoStyle,
    this.scaleFactor = 1.0,
    this.widgetPadding = 0,
    this.transposeIncrement = 0,
    this.scrollSpeed = 0,
    this.lineHeight = 8.0,
    this.horizontalAlignment = CrossAxisAlignment.center,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.leadingWidget,
    this.trailingWidget,
  });

  // final String lyrics;
  // final TextStyle textStyle;
  // final TextStyle chordStyle;
  // final TextStyle structureStyle;

  final Function onTapChord;

  /// To help stop overflow, this should be the sum of left & right padding
  final int widgetPadding;

  /// Transpose Increment for the Chords,
  /// default value is 0, which means no transpose is applied
  final int transposeIncrement;

  /// Auto Scroll Speed,
  /// default value is 0, which means no auto scroll is applied
  final int scrollSpeed;

  /// Extra height between each line
  final double lineHeight;

  /// Widget before the lyrics starts
  final Widget? leadingWidget;

  /// Widget after the lyrics finishes
  final Widget? trailingWidget;

  /// Horizontal alignment
  final CrossAxisAlignment horizontalAlignment;

  /// Scale factor of chords and lyrics
  final double scaleFactor;

  /// Define physics of scrolling
  final ScrollPhysics scrollPhysics;

  /// If not defined it will be the bold version of [textStyle]
  // final TextStyle chorusStyle;

  /// If not defined it will be the italic version of [textStyle]
  // final TextStyle? capoStyle;

  @override
  SongDetailWidgetState createState() => SongDetailWidgetState();
}

class SongDetailWidgetState extends ConsumerState<SongDetailWidget> {
  late final ScrollController _controller;

  // late TextStyle chorusStyle;
  late TextStyle capoStyle;
  late TextStyle commentStyle;
  List<Section> _sections = List.empty(growable: true);
  ChordLyricsDocument? _chordLyricsDocument;

  List<SongStructure> _structures = List.empty(growable: true);
  final Map<int, GlobalKey> _itemKey = {};
  final _scrollController = ScrollController();

  late TextStyle _textStyle;
  late TextStyle _chordStyle;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getTextStyles();
      await _processSong();
    });
  }

  void _getTextStyles() {
    _textStyle = WidgetUtils.getLyricsStyle(context).copyWith(
      fontSize: ref.watch(userSettingsNotifierProvider).textSize?.size ?? 18,
    );
    _chordStyle = WidgetUtils.getChordsStyle(context).copyWith(
      fontSize: ref.watch(userSettingsNotifierProvider).textSize?.size ?? 18,
    );
  }

  Future<void> _processSong() async {
    _processText();

    setState(() {
      _chordLyricsDocument = ref.watch(chordProcessorProvider).document;
      final lines = _chordLyricsDocument!.chordLyricsLines;
      ref.read(songNotifierProvider.notifier).getSections(lines);
      _sections = ref.watch(songNotifierProvider).sections;
      _structures = _sections.map((e) => e.structure).toList();
      for (var i = 0; i < _structures.length; i++) {
        _itemKey[i] = GlobalKey();
      }
    });
  }

  void _processText() {
    ref.read(chordProcessorProvider.notifier).processText(
          text: ref.watch(songNotifierProvider).song.lyrics!,
          lyricsStyle: _textStyle,
          chordStyle: _chordStyle,
          widgetPadding: widget.widgetPadding,
          scaleFactor: widget.scaleFactor,
          transposeIncrement:
              ref.watch(songNotifierProvider).transposeIncremenet,
          media: MediaQuery.of(context).size.width - 48,
          songViewMode: ref.watch(userSettingsNotifierProvider).songView ??
              SongViewMode.american,
          key: ref.watch(songNotifierProvider).song.key ?? 'C',
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listens();
    if (_chordLyricsDocument == null) return const SizedBox();
    if (_chordLyricsDocument!.chordLyricsLines.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      controller: _controller,
      physics: widget.scrollPhysics,
      child: Column(
        crossAxisAlignment: widget.horizontalAlignment,
        children: [
          const SizedBox(
            height: 24,
          ),
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sections.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.colorScheme.onSurfaceVariant,
                ),
                child: _buildLines(index, context),
              );
            },
          ),
          if (widget.trailingWidget != null) widget.trailingWidget!,
        ],
      ),
    );
  }

  void _listens() {
    ref
      ..listen(userSettingsNotifierProvider, (previous, next) {
        if (previous?.songView != next.songView) {
          _processSong();
        }
      })
      ..listen(userSettingsNotifierProvider, (previous, next) {
        setState(() {
          _textStyle = _textStyle.copyWith(
            fontSize: ref.watch(userSettingsNotifierProvider).textSize?.size,
          );
          _chordStyle = _chordStyle.copyWith(
            fontSize: ref.watch(userSettingsNotifierProvider).textSize?.size,
          );
        });
        _processSong();
      })
      ..listen(songNotifierProvider, (previous, next) {
        if (previous?.selectedSectionIndex != next.selectedSectionIndex) {
          _scrollToIndex();
        }
      })
      ..listen(songNotifierProvider, (previous, next) {
        if (previous?.transposeIncremenet != next.transposeIncremenet) {
          _processText();
          _chordLyricsDocument = ref.watch(chordProcessorProvider).document;
          final lines = _chordLyricsDocument!.chordLyricsLines;
          ref.read(songNotifierProvider.notifier).getSections(lines);
          _sections = ref.watch(songNotifierProvider).sections;
          _structures = _sections.map((e) => e.structure).toList();
        }
      });
  }

  void _scrollToIndex() {
    final item = ref.watch(songNotifierProvider).selectedSectionIndex;
    if (item == null) return;

    final indexToScrollTo =
        _structures.indexWhere((element) => element.item == item);
    if (indexToScrollTo == -1) return;

    setState(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
      );

      Future.delayed(const Duration(milliseconds: 350), () {
        final globalKey = _itemKey[indexToScrollTo];
        if (globalKey != null) {
          final itemContext = globalKey.currentContext;
          if (itemContext != null) {
            Scrollable.ensureVisible(
              itemContext,
              alignment: 0.5,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  Widget _buildLines(int index, BuildContext context) {
    return Column(
      key: _itemKey[index],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Color(_sections[index].structure.item.color),
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
                  _sections[index].structure.item.shortName,
                  style: context.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _sections[index].structure.item.name,
                style: context.textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.shadow,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(
            height: widget.lineHeight,
          ),
          itemCount: _sections[index].lines.length,
          itemBuilder: (context, index2) {
            final line = _sections[index].lines[index2];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ref.watch(userSettingsNotifierProvider).songView !=
                    SongViewMode.lyrics)
                  _buildChordsLine(line),
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

  Widget _buildChordsLine(ChordLyricsLine line) {
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
  Section(this.lines, this.structure);

  final List<ChordLyricsLine> lines;
  final SongStructure structure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Section &&
          runtimeType == other.runtimeType &&
          structure.item.name == other.structure.item.name;

  @override
  int get hashCode => structure.item.name.hashCode;
}
