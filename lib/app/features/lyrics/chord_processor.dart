import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/lyrics/chord_processor_state.dart';
import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
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
    required List<RawSection> rawSections,
    required List<StructureItem> structures,
    required TextStyle lyricsStyle,
    required TextStyle chordStyle,
    required double media,
    required String key,
    double scaleFactor = 1.0,
    int widgetPadding = 0,
    int transposeIncrement = 0,
    SongViewMode songViewMode = SongViewMode.american,
  }) {
    final chordTransposer = ChordTransposer(
      songViewMode,
      transpose: transposeIncrement,
      key: key,
    );

    _textScaleFactor = scaleFactor;
    final sections = <Section>[];

    for (final rawSection in rawSections) {
      final lyricsLine = <SongLines>[];
      if (rawSection.content != null) {
        final lines = rawSection.content!.split('\n');

        for (final line in lines) {
          if (_isLongLine(line, lyricsStyle, media)) {
            _handleLongLine(
              currentLine: line,
              chordLyricsLines: lyricsLine,
              lyricsStyle: lyricsStyle,
              chordStyle: chordStyle,
              widgetPadding: widgetPadding,
              media: media,
              chordTransposer: chordTransposer,
            );
          } else {
            lyricsLine.add(
              _processLine(
                line.trim(),
                lyricsStyle,
                chordStyle,
                chordTransposer,
              ),
            );
          }
        }
      }
      sections.add(
        Section(
          lyricsLine,
          SongStructure(
            rawSection.structureItem ?? StructureItem.none,
            rawSection.structureItem?.index ?? 0,
          ),
        ),
      );
    }

    final originalSections = sections;
    final modifiedDocumentContent = structures
        .map(
          (structure) => sections.firstWhere(
            (section) => section.structure.item == structure,
            orElse: () => Section(
              [],
              SongStructure(structure, structure.index),
            ),
          ),
        )
        .toList();

    state = state.copyWith(
      content: Content(
        sections: modifiedDocumentContent,
        originalSections: originalSections,
      ),
    );
  }

  bool _isLongLine(String currentLine, TextStyle lyricsStyle, double media) =>
      _getTextWidthFromStyle(currentLine, lyricsStyle) >= media;

  void _handleLongLine({
    required String currentLine,
    required List<SongLines> chordLyricsLines,
    required TextStyle lyricsStyle,
    required TextStyle chordStyle,
    required int widgetPadding,
    required double media,
    required ChordTransposer chordTransposer,
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
          chordLyricsLines.add(_processLine(
            currentLine.substring(characterIndex, lastSpace).trim(),
            lyricsStyle,
            chordStyle,
            chordTransposer,
          ));
          currentCharacters = '';
          characterIndex = lastSpace;
        }
      }
    }
    chordLyricsLines.add(_processLine(
      currentLine.substring(characterIndex, currentLine.length).trim(),
      lyricsStyle,
      chordStyle,
      chordTransposer,
    ));
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

  SongLines _processLine(
    String line,
    TextStyle lyricsStyle,
    TextStyle chordStyle,
    ChordTransposer chordTransposer,
  ) {
    final chordLyricsLine = SongLines();
    var lyricsSoFar = '';
    var chordsSoFar = '';
    var chordHasStarted = false;

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
    chordLyricsLine.lyrics += lyricsSoFar;

    return chordLyricsLine;
  }
}
