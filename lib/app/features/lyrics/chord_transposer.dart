enum ChordNotation { italian, american, numeric }

extension ChordNotationValues on ChordNotation {
  String get name {
    switch (this) {
      case ChordNotation.american:
        return 'American Chords';
      case ChordNotation.italian:
        return 'Italian Chords';
      case ChordNotation.numeric:
        return 'Numbers';
    }
  }

  String get example {
    switch (this) {
      case ChordNotation.american:
        return 'C#';
      case ChordNotation.italian:
        return 'Do#';
      case ChordNotation.numeric:
        return 'IV';
    }
  }
}

class ChordTransposer {
  ChordTransposer(
    this.chordNotation, {
    this.transpose = 0,
    required this.key,
  }) {
    switch (chordNotation) {
      case ChordNotation.italian:
        cycle = italianNotes;
        break;
      case ChordNotation.american:
        cycle = americanNotes;
        break;
      case ChordNotation.numeric:
        cycle = romanNumerals;
        break;
    }
  }

  final ChordNotation chordNotation;
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

  static const List<String> italianNotes = [
    'Do',
    'Do#',
    'Re',
    'Re#',
    'Mi',
    'Fa',
    'Fa#',
    'Sol',
    'Sol#',
    'La',
    'La#',
    'Si'
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
    if (transpose == 0 && chordNotation != ChordNotation.numeric) {
      return chord;
    }
    final outChord = <String>[];

    for (final partChord in chord.split('/')) {
      outChord.add(_processChord(partChord));
    }
    return outChord.join('/');
  }

  String _processChord(String chord) {
    if (chordNotation == ChordNotation.numeric) {
      return _toNumeric(chord);
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

  String _toNumeric(String chord) {
    // Match the chord root and its suffix
    final match = RegExp(r'^([A-G]#?)(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!; // The root note (e.g., G, Am)
    final suffix = match.group(2)!; // The rest of the chord (e.g., m7, sus4)

    // Extract the key root and mode (major or minor)
    final keyMatch =
        RegExp(r'^([A-G]#?)\s+(Major|minor)$', caseSensitive: false)
            .firstMatch(key);
    if (keyMatch == null) return chord;

    final keyRoot = keyMatch.group(1)!;
    final keyMode = keyMatch.group(2)!.toLowerCase();

    // Find the index of the key root and chord root in the American note system
    final keyIndex = americanNotes.indexOf(keyRoot);
    final chordIndex = americanNotes.indexOf(root);

    // If the chord root is not found in the cycle, return the chord unchanged
    if (chordIndex == -1) return chord;

    // Calculate the relative degree of the chord based on the key
    var numericValue = (chordIndex - keyIndex + 12) % 12;

    // Convert the numeric value to the corresponding scale degree in the key
    var scaleDegree = -1;
    switch (numericValue) {
      case 0:
        scaleDegree = 1;
        break; // I (Root)
      case 2:
        scaleDegree = 2;
        break; // II
      case 4:
        scaleDegree = 3;
        break; // III
      case 5:
        scaleDegree = 4;
        break; // IV
      case 7:
        scaleDegree = 5;
        break; // V
      case 9:
        scaleDegree = 6;
        break; // VI
      case 11:
        scaleDegree = 7;
        break; // VII
      default:
        return chord; // Return unchanged if not a valid scale degree
    }

    // Convert the scale degree to Roman numerals
    var romanNumeral = romanNumerals[(scaleDegree - 1) % 7];

    // Adjust for minor or major chords based on the key mode
    if (keyMode == 'minor' && [1, 4, 5].contains(scaleDegree)) {
      romanNumeral = romanNumeral.toLowerCase(); // Minor chords in minor key
    } else if (keyMode == 'major' && [2, 3, 6].contains(scaleDegree)) {
      romanNumeral = romanNumeral.toLowerCase(); // Minor chords in major key
    }

    // Return the numeric notation with the converted suffix
    return romanNumeral + _convertSuffix(suffix);
  }

  String _convertSuffix(String suffix) {
    suffix = suffix.replaceAll('maj', 'Δ');
    suffix = suffix.replaceAll('m', '');
    suffix = suffix.replaceAll('sus', 'sus');
    suffix = suffix.replaceAll('aug', '+');
    suffix = suffix.replaceAll('dim', '°');
    return suffix;
  }
}
