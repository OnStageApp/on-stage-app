import 'dart:math';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/lyrics/chord_processor_state.dart';
import 'package:on_stage_app/app/features/lyrics/chord_transposer.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_document.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_lyrics_line.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/chord_type_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/user_settings/domain/chord_type_view_enum.dart';
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
    required SongKey originalSongKey,
    required SongKey updateSongKey,
    required ChordViewMode chordViewMode,
    double scaleFactor = 1.0,
    int widgetPadding = 0,
    SongViewMode songViewMode = SongViewMode.both,
    ChordViewPref? chordViewPref,
  }) {
    final transposeIncrement = differenceFrom(originalSongKey, updateSongKey);

    final chordTransposer = ChordTransposer(
      originalSongKey: originalSongKey,
      transpose: transposeIncrement,
      songKeyToBeUpdated: updateSongKey,
      chordViewMode: chordViewMode,
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
              songViewMode: songViewMode,
            );
          } else {
            lyricsLine.add(
              _processLine(
                line.trim(),
                lyricsStyle,
                chordStyle,
                chordTransposer,
                songViewMode,
              ),
            );
          }
        }
      }
      sections.add(
        Section(lyricsLine, rawSection.structureItem ?? StructureItem.none),
      );
    }

    final originalSections = sections;
    final modifiedDocumentContent = structures
        .map(
          (structure) => sections.firstWhere(
            (section) => section.structure == structure,
            orElse: () => Section(
              [],
              structure,
            ),
          ),
        )
        .toList();

    // Then compress consecutive duplicate sections
    final compressedSections = <Section>[];

    if (modifiedDocumentContent.isNotEmpty) {
      var currentSection = modifiedDocumentContent[0];
      var count = 1;

      for (var i = 1; i < modifiedDocumentContent.length; i++) {
        if (modifiedDocumentContent[i] == currentSection) {
          count++;
        } else {
          compressedSections.add(
            Section(
              currentSection.lines,
              currentSection.structure,
              count: count,
            ),
          );
          currentSection = modifiedDocumentContent[i];
          count = 1;
        }
      }

      // Add the last section
      compressedSections.add(
        Section(currentSection.lines, currentSection.structure, count: count),
      );
    }

    state = state.copyWith(
      content: Content(
        sections: compressedSections,
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
    required SongViewMode songViewMode,
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
          chordLyricsLines.add(
            _processLine(
              currentLine.substring(characterIndex, lastSpace).trim(),
              lyricsStyle,
              chordStyle,
              chordTransposer,
              songViewMode,
            ),
          );
          currentCharacters = '';
          characterIndex = lastSpace;
        }
      }
    }
    chordLyricsLines.add(
      _processLine(
        currentLine.substring(characterIndex, currentLine.length).trim(),
        lyricsStyle,
        chordStyle,
        chordTransposer,
        songViewMode,
      ),
    );
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
    SongViewMode songViewMode,
  ) {
    final chordLyricsLine = SongLines();
    var lyricsSoFar = '';
    var chordsSoFar = '';
    var chordHasStarted = false;
    final isChordOnlyLine =
        !line.replaceAll(RegExp(r'\[.*?\]'), '').trim().isNotEmpty;
    var isFirstChord = true;

    line.split('').forEach(
      (character) {
        if (character == ']') {
          final double leadingSpace;

          if (isChordOnlyLine || songViewMode == SongViewMode.chords) {
            leadingSpace = isFirstChord ? 0 : 16.0;
          } else {
            final sizeOfLeadingLyrics =
                _getTextWidthFromStyle(lyricsSoFar, lyricsStyle);
            final lastChordText = chordLyricsLine.chords.isNotEmpty
                ? chordLyricsLine.chords.last.chordText
                : '';
            final lastChordWidth =
                _getTextWidthFromStyle(lastChordText, chordStyle);
            leadingSpace = max(0, sizeOfLeadingLyrics - lastChordWidth);
          }

          final transposedChord = chordTransposer.transposeChord(chordsSoFar);
          chordLyricsLine.chords.add(Chord(leadingSpace, transposedChord));

          if (!isChordOnlyLine && songViewMode != SongViewMode.chords) {
            chordLyricsLine.lyrics += lyricsSoFar;
          }

          lyricsSoFar = '';
          chordsSoFar = '';
          chordHasStarted = false;
          isFirstChord = false;
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

    // Add any remaining lyrics text, but only if not in chords-only mode
    if (!isChordOnlyLine && songViewMode != SongViewMode.chords) {
      chordLyricsLine.lyrics += lyricsSoFar;
    }

    return chordLyricsLine;
  }

  int differenceFrom(SongKey oldKey, SongKey newKey) {
    if (oldKey.chord == null || newKey.chord == null) {
      return 0;
    }

    final oldIndex = _getSemitone(oldKey);
    final newIndex = _getSemitone(newKey);

    var difference = newIndex - oldIndex;
    if (difference < 0) {
      difference += 12;
    }

    return difference;
  }

  static int _getSemitone(SongKey key) {
    if (key.chord == null) return 0;

    final baseNote = key.chord!.name;
    final noteName = switch (key.keyType) {
      ChordTypeEnum.sharp => '$baseNote#',
      ChordTypeEnum.flat => '${baseNote}b',
      ChordTypeEnum.natural => baseNote,
    };

    return noteToSemitone[noteName] ?? 0;
  }

  static const Map<String, int> noteToSemitone = {
    'C': 0,
    'C#': 1,
    'Db': 1,
    'D': 2,
    'D#': 3,
    'Eb': 3,
    'E': 4,
    'F': 5,
    'F#': 6,
    'Gb': 6,
    'G': 7,
    'G#': 8,
    'Ab': 8,
    'A': 9,
    'A#': 10,
    'Bb': 10,
    'B': 11,
  };
}
