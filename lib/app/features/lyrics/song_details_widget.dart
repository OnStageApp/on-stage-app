import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/lyrics/chord_parser.dart';
import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongDetailWidget extends StatefulWidget {
  const SongDetailWidget({
    required this.lyrics,
    required this.textStyle,
    required this.chordStyle,
    required this.structureStyle,
    required this.onTapChord,
    super.key,
    this.chorusStyle,
    this.commentStyle,
    this.capoStyle,
    this.scaleFactor = 1.0,
    this.showChord = true,
    this.widgetPadding = 0,
    this.transposeIncrement = 0,
    this.scrollSpeed = 0,
    this.lineHeight = 8.0,
    this.horizontalAlignment = CrossAxisAlignment.center,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.leadingWidget,
    this.trailingWidget,
    this.chordNotation = ChordNotation.american,
  });

  final String lyrics;
  final TextStyle textStyle;
  final TextStyle chordStyle;
  final TextStyle structureStyle;
  final bool showChord;
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

  /// Notation that will be handled by the transposer
  final ChordNotation chordNotation;

  /// Define physics of scrolling
  final ScrollPhysics scrollPhysics;

  /// If not defined it will be the bold version of [textStyle]
  final TextStyle? chorusStyle;

  /// If not defined it will be the italic version of [textStyle]
  final TextStyle? capoStyle;

  /// If not defined it will be the italic version of [textStyle]
  final TextStyle? commentStyle;

  @override
  State<SongDetailWidget> createState() => _SongDetailWidgetState();
}

class _SongDetailWidgetState extends State<SongDetailWidget> {
  late final ScrollController _controller;
  late TextStyle chorusStyle;
  late TextStyle capoStyle;
  late TextStyle commentStyle;
  bool _isChorus = false;
  bool _isComment = false;

  @override
  void initState() {
    super.initState();
    chorusStyle = widget.chorusStyle ??
        widget.textStyle.copyWith(fontWeight: FontWeight.bold);
    capoStyle = widget.capoStyle ??
        widget.textStyle.copyWith(fontStyle: FontStyle.italic);
    commentStyle = widget.commentStyle ??
        widget.textStyle.copyWith(
          fontStyle: FontStyle.italic,
          fontSize: widget.textStyle.fontSize! - 2,
        );
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle getLineTextStyle() {
    if (_isChorus) {
      return chorusStyle;
    } else if (_isComment) {
      return commentStyle;
    } else {
      return widget.textStyle;
    }
  }

  void getVerse() {}

  @override
  Widget build(BuildContext context) {
    final chordProcessor = ChordProcessor(context, widget.chordNotation);
    final chordLyricsDocument = chordProcessor.processText(
      text: widget.lyrics,
      lyricsStyle: widget.textStyle,
      chordStyle: widget.chordStyle,
      chorusStyle: chorusStyle,
      widgetPadding: widget.widgetPadding,
      scaleFactor: widget.scaleFactor,
      transposeIncrement: widget.transposeIncrement,
    );
    final structures = <String>[];
    chordLyricsDocument.chordLyricsLines.map((e) {
      structures.add(e.structure);
    }).toList();

    var lines = chordLyricsDocument.chordLyricsLines;
    List<SongObject> sections = [];
    List<ChordLyricsLine> items = [];
    String structure = '';
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].structure.isNotNullEmptyOrWhitespace ||
          i == lines.length - 1) {
        if (items.isNotEmpty) {
          print('Items added ${items.length}');
          print('items added as  $structure');
          sections.add(SongObject(items, structure));
        }
        print('Structure: ${lines[i].structure}');
        print('items: ${items.length} ${items.map((e) => e.lyrics)}');
        print('lyrics: ${lines[i].lyrics}');

        structure = lines[i].structure;
        items = [];
      } else {
        print(lines[i].lyrics);
        items.add(lines[i]);
      }
    }
    print('asdasdasdsa');
    print(sections);

    if (chordLyricsDocument.chordLyricsLines.isEmpty) return Container();
    return SingleChildScrollView(
      controller: _controller,
      physics: widget.scrollPhysics,
      child: Column(
        crossAxisAlignment: widget.horizontalAlignment,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sections[index].structure.isNotEmpty)
                      Container(
                        child: RichText(
                          text: TextSpan(
                            text: sections[index].structure,
                            style: widget.structureStyle,
                          ),
                          textScaler: TextScaler.linear(widget.scaleFactor),
                        ),
                      ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(
                        height: widget.lineHeight,
                      ),
                      itemCount: sections[index].lines.length,
                      itemBuilder: (context, index2) {
                        final line = sections[index].lines[index2];
                        if (line.isStartOfChorus()) {
                          _isChorus = true;
                        }
                        if (line.isEndOfChorus()) {
                          _isChorus = false;
                        }
                        if (line.isComment()) {
                          _isComment = true;
                        } else {
                          _isComment = false;
                        }
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.showChord) _buildChordsLine(line),
                              RichText(
                                text: TextSpan(
                                  text: line.lyrics,
                                  style: getLineTextStyle(),
                                ),
                                textScaler:
                                    TextScaler.linear(widget.scaleFactor),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    text: line.structure.isNotEmpty
                                        ? line.structure
                                        : '',
                                    style: widget.structureStyle,
                                  ),
                                  textScaler:
                                      TextScaler.linear(widget.scaleFactor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          if (widget.trailingWidget != null) widget.trailingWidget!,
        ],
      ),
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
                    textScaleFactor: widget.scaleFactor,
                    text: TextSpan(
                      text: chord.chordText,
                      style: widget.chordStyle,
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
    if (oldWidget.scrollSpeed != widget.scrollSpeed) {
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    if (widget.scrollSpeed <= 0) {
      // stop scrolling if the speed is 0 or less
      _controller.jumpTo(_controller.offset);
      return;
    }

    if (_controller.offset >= _controller.position.maxScrollExtent) return;

    final seconds =
        (_controller.position.maxScrollExtent / (widget.scrollSpeed)).floor();

    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(
        seconds: seconds,
      ),
      curve: Curves.linear,
    );
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

class SongObject {
  final List<ChordLyricsLine> lines;
  final String structure;

  SongObject(this.lines, this.structure);
}
