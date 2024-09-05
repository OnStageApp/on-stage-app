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

  // bool isChorus = false;

  /// Process the text to get the parsed ChordLyricsDocument
  void processText({
    required String text,
    required TextStyle lyricsStyle,
    required TextStyle chordStyle,
    // required TextStyle chorusStyle,
    required double media,
    double scaleFactor = 1.0,
    int widgetPadding = 0,
    int transposeIncrement = 0,
  }) {
    final chordTransposer =
        ChordTransposer(ChordNotation.american, transpose: transposeIncrement);
    //Here it goes and search for structure text and put it on a new line
    text = _breakOnStructure(text);
    final lines = text.split(RegExp(r'(\{[^\}]*\})|\n'));
    // final metadata = MetadataHandler();
    _textScaleFactor = scaleFactor;
    chordTransposer.transpose = transposeIncrement;

    /// List to store our updated lines without overflows
    final newLines = <String>[];
    var currentLine = '';

    ///loop through the lines
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
        //otherwise just add the regular line
        newLines.add(currentLine.trim());
      }
    }

    final chordLyricsLines = newLines
        .map<ChordLyricsLine>(
          (line) => _processLine(
            line,
            lyricsStyle,
            chordStyle,
            // chorusStyle,
            chordTransposer,
          ),
        )
        .toList();

    state = state.copyWith(
      document: ChordLyricsDocument(
        chordLyricsLines,
        //TODO: see if it's needed, i just commented these and the metadata class from the model
        // capo: metadata.capo,
        // artist: metadata.artist,
        // title: metadata.title,
        // key: metadata.key,
      ),
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

    //work our way through the line and split when we need to
    for (var j = 0; j < currentLine.length; j++) {
      character = currentLine[j];
      if (character == '[') {
        chordHasStartedOuter = true;
      } else if (character == ']') {
        chordHasStartedOuter = false;
      } else if (!chordHasStartedOuter) {
        currentCharacters += character;
        if (character == ' ') {
          //use this marker to only split where there are spaces. We can trim later.
          lastSpace = j;
        }

//This is the point where we need to split
//widgetPadding has been added as a parameter to be passed from the build function
//It is intended to allow for padding in the widget when comparing it to screen width
//An additional buffer of around 10 might be needed to definitely stop overflow (ie. padding + 10).
        if (_getTextWidthFromStyle(currentCharacters, lyricsStyle) +
                widgetPadding >=
            media) {
          newLines.add(currentLine.substring(characterIndex, lastSpace).trim());
          currentCharacters = '';
          characterIndex = lastSpace;
        }
      }
    }
//add the rest of the long line
    newLines
        .add(currentLine.substring(characterIndex, currentLine.length).trim());
  }

  /// Return the textwidth of the text in the given style
  double _getTextWidthFromStyle(String text, TextStyle textStyle) {
    final layout = TextPainter(
      textScaler: TextScaler.linear(_textScaleFactor),
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // print('layout.size.width: ${layout.size.width}, text: $text');
    return layout.size.width;
  }

  ChordLyricsLine _processLine(
    String line,
    TextStyle lyricsStyle,
    TextStyle chordStyle,
    // TextStyle chorusStyle,
    ChordTransposer chordTransposer,
  ) {
    final chordLyricsLine = ChordLyricsLine();
    var lyricsSoFar = '';
    var chordsSoFar = '';
    var chordHasStarted = false;

    // if (line.contains('{soc}') || line.contains('{start_of_chorus}')) {
    //   isChorus = true;
    // } else if (line.contains('{eoc}') || line.contains('{end_of_chorus}')) {
    //   isChorus = false;
    // }

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
            // print('current TRANSPOSED Chord: $transposedChord');
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
