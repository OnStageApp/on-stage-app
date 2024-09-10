import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/lyrics/chord_processor_state.dart';
import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chord_processor.g.dart';

@Riverpod(keepAlive: true)
class ChordProcessor extends _$ChordProcessor {
  @override
  ChordProcessorState build() {
    return const ChordProcessorState();
  }

  late double _textScaleFactor;

  void processText({
    required String text,
    required TextStyle lyricsStyle,
    required TextStyle chordStyle,
    required double media,
    double scaleFactor = 1.0,
    int widgetPadding = 0,
    int transposeIncrement = 0,
    ChordNotation chordNotation = ChordNotation.american,
    required String key,
  }) {
    final chordTransposer = ChordTransposer(
      chordNotation,
      transpose: transposeIncrement,
      key: key,
    );

    text = _breakOnStructure(text);
    final lines = text.split(RegExp(r'(\{[^\}]*\})|\n'));
    _textScaleFactor = scaleFactor;

    final newLines = <String>[];
    var currentLine = '';

    for (var i = 0; i < lines.length; i++) {
      currentLine = lines[i];

      if (_isLongLine(currentLine, lyricsStyle, media)) {
        _handleLongLine(
          currentLine: currentLine,
          newLines: newLines,
          lyricsStyle: lyricsStyle,
          widgetPadding: widgetPadding,
          media: media,
        );
      } else {
        newLines.add(currentLine.trim());
      }
    }

    final chordLyricsLines = newLines
        .map<ChordLyricsLine>(
          (line) => _processLine(
            line,
            lyricsStyle,
            chordStyle,
            chordTransposer,
          ),
        )
        .toList();

    state = state.copyWith(
      document: ChordLyricsDocument(chordLyricsLines),
    );
  }

  bool _isLongLine(String currentLine, TextStyle lyricsStyle, double media) =>
      _getTextWidthFromStyle(currentLine, lyricsStyle) >= media;

  String _breakOnStructure(String text) {
    return text.replaceAllMapped(RegExp('(<[^>]*>)'), (match) {
      return '\n${match.group(0)}\n';
    });
  }

  void _handleLongLine({
    required List<String> newLines,
    required String currentLine,
    required TextStyle lyricsStyle,
    required int widgetPadding,
    required double media,
  }) {
    var character = '';
    var characterIndex = 0;
    var currentCharacters = '';
    var chordHasStartedOuter = false;
    var lastSpace = 0;

    for (var j = 0; j < currentLine.length; j++) {
      character = currentLine[j];
      if (character == '[') {
        chordHasStartedOuter = true;
      } else if (character == ']') {
        chordHasStartedOuter = false;
      } else if (!chordHasStartedOuter) {
        currentCharacters += character;
        if (character == ' ') {
          lastSpace = j;
        }

        if (_getTextWidthFromStyle(currentCharacters, lyricsStyle) +
                widgetPadding >=
            media) {
          newLines.add(currentLine.substring(characterIndex, lastSpace).trim());
          currentCharacters = '';
          characterIndex = lastSpace;
        }
      }
    }
    newLines
        .add(currentLine.substring(characterIndex, currentLine.length).trim());
  }

  double _getTextWidthFromStyle(String text, TextStyle textStyle) {
    final layout = TextPainter(
      textScaler: TextScaler.linear(_textScaleFactor),
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return layout.size.width;
  }

  ChordLyricsLine _processLine(
    String line,
    TextStyle lyricsStyle,
    TextStyle chordStyle,
    ChordTransposer chordTransposer,
  ) {
    final chordLyricsLine = ChordLyricsLine();
    var lyricsSoFar = '';
    var chordsSoFar = '';
    var chordHasStarted = false;

    if (RegExp(r'^.*<[^>]*>.*$').hasMatch(line)) {
      _handleStructure(line, chordLyricsLine);
    } else {
      line.split('').forEach(
        (character) {
          if (character == ']') {
            final sizeOfLeadingLyrics =
                _getTextWidthFromStyle(lyricsSoFar, lyricsStyle);

            final lastChordText = chordLyricsLine.chords.isNotEmpty
                ? chordLyricsLine.chords.last.chordText
                : '';

            final lastChordWidth =
                _getTextWidthFromStyle(lastChordText, chordStyle);

            final double leadingSpace =
                max(0, sizeOfLeadingLyrics - lastChordWidth);

            final transposedChord = chordTransposer.transposeChord(chordsSoFar);
            chordLyricsLine.chords.add(Chord(leadingSpace, transposedChord));
            chordLyricsLine.lyrics += lyricsSoFar;
            lyricsSoFar = '';
            chordsSoFar = '';
            chordHasStarted = false;
          } else if (character == '[') {
            chordHasStarted = true;
          } else {
            if (chordHasStarted) {
              chordsSoFar += character;
            } else {
              lyricsSoFar += character;
            }
          }
        },
      );
    }
    chordLyricsLine.lyrics += lyricsSoFar;

    return chordLyricsLine;
  }

  void _handleStructure(String line, ChordLyricsLine chordLyricsLine) {
    final regex = RegExp('<([^>]*)>');
    final modifiedLine = line.replaceAllMapped(regex, (match) {
      return match.group(1)!;
    });
    chordLyricsLine.structure = modifiedLine;
  }
}
