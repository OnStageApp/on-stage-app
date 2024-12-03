import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';

class ChordTransposer {
  ChordTransposer(
    this.chordNotation, {
    required this.key,
    this.transpose = 0,
  }) {
    cycle = americanNotes;

    switch (chordNotation) {
      case SongViewMode.lyrics:
        cycle = americanNotes;
      case SongViewMode.american:
        cycle = americanNotes;
      case SongViewMode.numeric:
        cycle = romanNumerals;
    }
  }

  final SongViewMode chordNotation;
  late List<String> cycle;
  int transpose;
  String key;

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

  static const List<String> americanNotes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
    'Db',
    'Eb',
    'Gb',
    'Ab',
    'Bb',
  ];

  static const List<String> romanNumerals = [
    'I',
    'ii',
    'iii',
    'IV',
    'V',
    'vi',
    'vii°',
  ];

  String transposeChord(String chord) {
    if (transpose == 0 && chordNotation != SongViewMode.numeric) {
      if (chordNotation == SongViewMode.american) {
        return _convertAccidentals(chord);
      } else {
        return chord;
      }
    }
    final outChord = <String>[];

    for (final partChord in chord.split('/')) {
      outChord.add(_processChord(partChord));
    }
    var result = outChord.join('/');

    if (chordNotation == SongViewMode.american) {
      result = _convertAccidentals(result);
    }

    return result;
  }

  String _processChord(String chord) {
    if (chordNotation == SongViewMode.numeric) {
      return _toNumeric(chord, key);
    }

    var index = cycle.lastIndexWhere((note) => chord.startsWith(note));
    if (index == -1) {
      return chord;
    }
    final chordFound = cycle[index];
    var simpleChord = chord.substring(0, chordFound.length);
    final otherPartChord = chord.substring(simpleChord.length);

    simpleChord = _handleFlatOrSharp(chord, simpleChord);
    index = cycle.indexOf(simpleChord);

    final newInd = (index + transpose + cycle.length) % cycle.length;
    final newChord = cycle[newInd];

    if (chordNotation == SongViewMode.american) {
      return _convertAccidentals(newChord + otherPartChord);
    } else {
      return newChord + otherPartChord;
    }
  }

  String _handleFlatOrSharp(String chord, String simpleChordParam) {
    var simpleChord = simpleChordParam;
    if (chord.startsWith('#', simpleChord.length)) {
      simpleChord += '#';
    }
    if (chord.startsWith('b', simpleChord.length)) {
      simpleChord = _fromFlatToSharp(simpleChord);
    }
    return simpleChord;
  }

  String _fromFlatToSharp(String simpleChord) {
    final index = cycle.indexOf(simpleChord) - 1 + cycle.length;
    return cycle[index % cycle.length];
  }

  String _toNumeric(String chord, String key) {
    final match = RegExp(r'^([A-G])([#b]?)(m|maj|min|dim|aug)?([#b]?)(.*)$')
        .firstMatch(chord);
    if (match == null) return chord;

    var root = match.group(1)!;
    var accidental = match.group(2) ?? '';
    final quality = match.group(3) ?? '';
    final accidental2 = match.group(4) ?? '';
    var suffix = match.group(5) ?? '';

    if (accidental2.isNotEmpty) {
      if (accidental.isNotEmpty) {
        // Both accidentals present, possibly an invalid chord
        return chord; // Or handle as needed
      } else {
        accidental = accidental2;
      }
    }

    root += accidental;
    suffix = quality + suffix;

    final keyMatch = RegExp(r'^([A-G][#b]?)(\s|$)').firstMatch(key);
    if (keyMatch == null) return chord;

    final keyRoot = keyMatch.group(1)!;

    // Semitone mapping
    final noteSemitoneMap = <String, int>{
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

    final keySemitone = noteSemitoneMap[keyRoot];
    final chordSemitone = noteSemitoneMap[root];

    if (keySemitone == null || chordSemitone == null) return chord;

    final interval = (chordSemitone - keySemitone + 12) % 12;

    // Extended scale steps and Roman numerals
    final scaleSteps = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    final romanNumerals = [
      'I',
      '♭II',
      'II',
      '♭III',
      'III',
      'IV',
      '♯IV/♭V',
      'V',
      '♭VI',
      'VI',
      '♭VII',
      'VII',
    ];

    final degreeIndex = scaleSteps.indexOf(interval);
    if (degreeIndex == -1) return chord;

    var romanNumeral = romanNumerals[degreeIndex];

    final isMinorChord = quality.startsWith('m') || quality.startsWith('min');

    // Adjust case based on chord quality
    if (isMinorChord) {
      romanNumeral = romanNumeral.toLowerCase();
    } else {
      romanNumeral = romanNumeral.toUpperCase();
    }

    return romanNumeral + _convertSuffix(suffix);
  }

  String _convertSuffix(String suffixChord) {
    var suffix = suffixChord;
    if (suffix.isEmpty) return '';
    suffix = suffix.replaceAll('maj', 'Δ');
    suffix = suffix.replaceAll('min', 'm');
    suffix =
        suffix.replaceAll('m', ''); // Minor is indicated by lowercase numeral
    suffix = suffix.replaceAll('aug', '+');
    suffix = suffix.replaceAll('dim', '°');
    return suffix;
  }

  String _convertAccidentals(String chord) {
    return chord
        .replaceAllMapped(
          RegExp('([A-G])([#b])'),
          (Match m) {
            final note = m.group(1)!;
            final accidental = m.group(2)!;
            final symbol = accidental == '#' ? '♯' : '♭';
            return note + symbol;
          },
        )
        .replaceAll('b', '♭')
        .replaceAll('#', '♯');
  }
}
