import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';

class ChordTransposer {
  ChordTransposer(
    this.chordNotation, {
    required this.key,
    this.transpose = 0,
  }) {
    cycle = defaultCycle;

    switch (chordNotation) {
      case SongViewMode.lyrics:
        cycle = defaultCycle;
      case SongViewMode.american:
        cycle = defaultCycle;
      case SongViewMode.numeric:
        cycle = romanNumerals;
    }
  }

  final SongViewMode chordNotation;
  late List<String> cycle;
  int transpose;
  String key;

  static const List<String> defaultCycle = [
    'C',
    'C#',
    'Db',
    'D',
    'D#',
    'Eb',
    'E',
    'F',
    'F#',
    'Gb',
    'G',
    'G#',
    'Ab',
    'A',
    'A#',
    'Bb',
    'B',
  ];

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

  // Maps to maintain the original style (sharp or flat) for each semitone
  static const Map<int, Map<String, String>> semitoneToNote = {
    0: {'sharp': 'C', 'flat': 'C'},
    1: {'sharp': 'C#', 'flat': 'Db'},
    2: {'sharp': 'D', 'flat': 'D'},
    3: {'sharp': 'D#', 'flat': 'Eb'},
    4: {'sharp': 'E', 'flat': 'E'},
    5: {'sharp': 'F', 'flat': 'F'},
    6: {'sharp': 'F#', 'flat': 'Gb'},
    7: {'sharp': 'G', 'flat': 'G'},
    8: {'sharp': 'G#', 'flat': 'Ab'},
    9: {'sharp': 'A', 'flat': 'A'},
    10: {'sharp': 'A#', 'flat': 'Bb'},
    11: {'sharp': 'B', 'flat': 'B'},
  };

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
      }
      return chord;
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

    // Extract the root note and the rest of the chord
    final match = RegExp(r'^([A-G][#b]?)(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final rootNote = match.group(1)!;
    final remainder = match.group(2) ?? '';

    // Get semitone value for the root note
    final semitone = noteToSemitone[rootNote];
    if (semitone == null) return chord;

    // Determine if the original chord used flats or sharps
    final usesFlat = rootNote.contains('b');

    // Calculate new semitone after transposition
    final newSemitone = (semitone + transpose + 12) % 12;

    // Get the new note preserving the original accidental style
    final newNote = semitoneToNote[newSemitone]![usesFlat ? 'flat' : 'sharp']!;

    return newNote + remainder;
  }

  String _toNumeric(String chord, String key) {
    final match =
        RegExp(r'^([A-G][#b]?)(maj|min|dim|aug|m)?(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!;
    final quality = match.group(2) ?? '';
    print('quality: $quality');
    final remainder = match.group(3) ?? '';
    print('remainder: $remainder');

    // Get semitones for both chord and key
    final chordSemitone = noteToSemitone[root];
    final keySemitone = noteToSemitone[key.replaceAll(RegExp('[^A-G#b]'), '')];

    if (chordSemitone == null || keySemitone == null) return chord;

    // Calculate interval
    final interval = (chordSemitone - keySemitone + 12) % 12;

    // Map interval to roman numeral
    final degreeMap = {
      0: 'I',
      2: 'II',
      4: 'III',
      5: 'IV',
      7: 'V',
      9: 'VI',
      11: 'VII',
    };

    var numeral = degreeMap[interval];
    if (numeral == null) {
      // Handle non-diatonic chords
      final flatInterval = (interval - 1 + 12) % 12;
      if (degreeMap.containsKey(flatInterval)) {
        numeral = '♭${degreeMap[flatInterval]}';
      } else {
        return chord; // Return original if can't map
      }
    }

    // Adjust case based on chord quality
    if (!quality.toLowerCase().startsWith('maj') &&
        (quality.startsWith('m') && RegExp('[a-z]').hasMatch(quality[0]) ||
            quality.startsWith('min'))) {
      print('$quality lowercase');
      numeral = numeral.toLowerCase();
    }

    return numeral + _convertSuffix(quality + remainder);
  }

  String _convertSuffix(String suffixChord) {
    var suffix = suffixChord;
    if (suffix.isEmpty) return '';
    suffix = suffix
        .replaceAll('maj', '')
        .replaceAll('min', 'm')
        .replaceAll('m', '') // Minor is indicated by lowercase numeral
        .replaceAll('aug', '+')
        .replaceAll('dim', '°');
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
