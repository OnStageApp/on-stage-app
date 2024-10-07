import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';

class ChordTransposer {
  ChordTransposer(
    this.chordNotation, {
    required this.key,
    this.transpose = 0,
  }) {
    switch (chordNotation) {
      case SongViewMode.lyrics:
        break;
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
    'B'
  ];

  static const List<String> romanNumerals = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII'
  ];

  String transposeChord(String chord) {
    if (transpose == 0 && chordNotation != SongViewMode.numeric) {
      return chord;
    }
    final outChord = <String>[];

    for (final partChord in chord.split('/')) {
      outChord.add(_processChord(partChord));
    }
    return outChord.join('/');
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

    return newChord + otherPartChord;
  }

  String _handleFlatOrSharp(String chord, String simpleChord) {
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
    // Match the chord root and its suffix
    final match = RegExp(r'^([A-G]#?)(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!; // The root note (e.g., G, A#)
    final suffix = match.group(2)!; // The rest of the chord (e.g., m7, sus4)

    // Extract the key root and mode (major or minor)
    final keyMatch =
        RegExp(r'^([A-G]#?)\s+(Major|minor)$', caseSensitive: false)
            .firstMatch(key);
    if (keyMatch == null) return chord;

    final keyRoot = keyMatch.group(1)!;
    final keyMode = keyMatch.group(2)!.toLowerCase();

    // Define the American note system
    final americanNotes = [
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
      'B'
    ];
    final keyIndex = americanNotes.indexOf(keyRoot);
    final chordIndex = americanNotes.indexOf(root);

    // If the chord root is not found in the cycle, return the chord unchanged
    if (chordIndex == -1) return chord;

    // Calculate the relative degree of the chord based on the key
    var numericValue = (chordIndex - keyIndex + 12) % 12;

    // Define Roman numerals with accidentals for chromatic chords
    final chromaticRomanNumerals = {
      0: 'I',
      1: 'bII',
      2: 'II',
      3: 'bIII',
      4: 'III',
      5: 'IV',
      6: '#IV',
      7: 'V',
      8: 'bVI',
      9: 'VI',
      10: 'bVII',
      11: 'VII'
    };

    // Determine if the chord is minor
    bool isMinorChord = suffix.contains('m');

    // Get the Roman numeral for the scale degree, with accidentals if needed
    var romanNumeral = chromaticRomanNumerals[numericValue] ?? chord;

    // Define expected major/minor scale degrees for a major key
    final majorKeyStructure = {
      0: 'maj',
      2: 'min',
      4: 'min',
      5: 'maj',
      7: 'maj',
      9: 'min',
      11: 'dim'
    };
    final minorKeyStructure = {
      0: 'min',
      2: 'dim',
      3: 'maj',
      5: 'min',
      7: 'min',
      8: 'maj',
      10: 'maj'
    };

    // Determine the expected chord quality (maj/min) based on the key
    final expectedQuality = keyMode == 'major'
        ? majorKeyStructure[numericValue]
        : minorKeyStructure[numericValue];

    // Adjust the Roman numeral notation to reflect actual and expected qualities
    if (expectedQuality == 'min' && !isMinorChord) {
      romanNumeral += 'Maj'; // Out-of-key major chord where minor is expected
    } else if (expectedQuality == 'maj' && isMinorChord) {
      romanNumeral += 'min'; // Out-of-key minor chord where major is expected
    } else if (isMinorChord) {
      romanNumeral = romanNumeral.toLowerCase(); // Standard lowercase for minor
    }

    // Convert chord suffix (e.g., 'maj', 'dim') based on notation preferences
    return romanNumeral + _convertSuffix(suffix);
  }

// Helper function to convert chord suffixes like "maj", "m7", "dim", "aug"
  String _convertSuffix(String suffix) {
    suffix = suffix.replaceAll('maj', 'Δ');
    suffix = suffix.replaceAll('m', '');
    suffix = suffix.replaceAll('sus', 'sus');
    suffix = suffix.replaceAll('aug', '+');
    suffix = suffix.replaceAll('dim', '°');
    return suffix;
  }
}
