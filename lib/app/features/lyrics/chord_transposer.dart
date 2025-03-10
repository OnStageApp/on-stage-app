import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/chord_type_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

class ChordTransposer {
  ChordTransposer({
    required this.songKeyToBeUpdated,
    required this.originalSongKey,
    required this.chordViewMode,
    this.transpose = 0,
  }) {
    cycle = defaultCycle;

    switch (chordViewMode) {
      case ChordViewMode.american:
        cycle = defaultCycle;
      case ChordViewMode.numbers:
        cycle = romanNumbers;
      case ChordViewMode.numerals:
        cycle = arabicNumerals;
    }
  }

  final ChordViewMode chordViewMode;
  late List<String> cycle;
  int transpose;
  final SongKey songKeyToBeUpdated;

  final SongKey originalSongKey;

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

  static const List<String> romanNumbers = [
    'I',
    'ii',
    'iii',
    'IV',
    'V',
    'vi',
    'vii°',
  ];

  static const List<String> arabicNumerals = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
  ];

  String transposeChord(String chord) {
    if (transpose == 0 &&
        (chordViewMode != ChordViewMode.numbers &&
            chordViewMode != ChordViewMode.numerals)) {
      if (chordViewMode == ChordViewMode.american) {
        return _convertAccidentals(chord);
      }
      return chord;
    }

    final outChord = <String>[];
    for (final partChord in chord.split('/')) {
      outChord.add(_processChord(partChord));
    }
    var result = outChord.join('/');

    if (chordViewMode == ChordViewMode.american) {
      result = _convertAccidentals(result);
    }

    return result;
  }

  final keySignatureStyle = {
    ChordsWithoutSharp.A: ChordTypeEnum.sharp, // F#, C#, G#
    ChordsWithoutSharp.B: ChordTypeEnum.sharp, // F#, C#, G#, D#, A#
    ChordsWithoutSharp.C: ChordTypeEnum.natural, // No accidentals
    ChordsWithoutSharp.D: ChordTypeEnum.sharp, // F#, C#
    ChordsWithoutSharp.E: ChordTypeEnum.sharp, // F#, C#, G#, D#
    ChordsWithoutSharp.F: ChordTypeEnum.flat, // B♭
    ChordsWithoutSharp.G: ChordTypeEnum.sharp, // F#
  };

  String _processChord(String chord) {
    if (chordViewMode == ChordViewMode.numbers ||
        chordViewMode == ChordViewMode.numerals) {
      return _toNumeric(chord, originalSongKey.name);
    }

    final match = RegExp(r'^([A-G][#b]?)(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final rootNote = match.group(1)!;
    final remainder = match.group(2) ?? '';

    final semitone = noteToSemitone[rootNote];
    if (semitone == null) return chord;

    final useFlatStyle = songKeyToBeUpdated.keyType == ChordTypeEnum.flat ||
        (songKeyToBeUpdated.keyType == ChordTypeEnum.natural &&
            keySignatureStyle[songKeyToBeUpdated.chord] == ChordTypeEnum.flat);
    final newSemitone = (semitone + transpose + 12) % 12;
    final newNote =
        semitoneToNote[newSemitone]![useFlatStyle ? 'flat' : 'sharp']!;

    return newNote + remainder;
  }

  String _toNumeric(String chord, String key) {
    final match =
        RegExp(r'^([A-G][#b]?)(maj|min|dim|aug|m)?(.*)$').firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!;
    final quality = match.group(2) ?? '';
    final remainder = match.group(3) ?? '';

    // Get semitones for both chord and key
    final chordSemitone = noteToSemitone[root];

    /// Clean speacial chars like ♯ and ♭, replace them with # and b
    final cleanedKey = key
        .replaceAll('♯', '#')
        .replaceAll('♭', 'b')
        .replaceAll(RegExp('[^A-G#b]'), '');
    final keySemitone = noteToSemitone[cleanedKey];
    if (chordSemitone == null || keySemitone == null) return chord;

    // Calculate interval
    final interval = (chordSemitone - keySemitone + 12) % 12;

    // Map interval to numeral
    final degreeMap = getDegreeMap();
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

    if (ChordViewMode.numerals == chordViewMode) {
      // Roman numerals logic remains the same
      if (!quality.toLowerCase().startsWith('maj') &&
          (quality.startsWith('m') && RegExp('[a-z]').hasMatch(quality[0]) ||
              quality.startsWith('min'))) {
        numeral = numeral.toLowerCase();
      }
      return numeral + _convertSuffix(quality + remainder);
    } else {
      // For Arabic numerals
      var chordQuality = '';

      // Check if remainder is just a number
      final isOnlyNumber = RegExp(r'^\d+$').hasMatch(remainder);

      if (!isOnlyNumber) {
        if ((quality.startsWith('m') || quality.startsWith('min')) &&
            remainder.isEmpty) {
          // Don't show 'm' for basic minor chords
          return numeral;
        } else if (quality.startsWith('m') || quality.startsWith('min')) {
          // Show 'm' for minor chords with extensions
          chordQuality = 'm';
        } else if (quality.startsWith('dim')) {
          chordQuality = '°';
        } else if (quality.startsWith('aug')) {
          chordQuality = '+';
        } else if (quality.toLowerCase().startsWith('maj')) {
          chordQuality = 'maj';
        }

        return numeral + chordQuality + remainder;
      }

      return numeral;
    }
  }

  Map<int, String> getDegreeMap() {
    if (ChordViewMode.numerals == chordViewMode) {
      return {
        0: 'I',
        2: 'II',
        4: 'III',
        5: 'IV',
        7: 'V',
        9: 'VI',
        11: 'VII',
      };
    } else {
      return {
        0: '1',
        2: '2',
        4: '3',
        5: '4',
        7: '5',
        9: '6',
        11: '7',
      };
    }
  }

  String _convertSuffix(String suffixChord) {
    var suffix = suffixChord;
    if (suffix.isEmpty) return '';

    if (ChordViewMode.numerals == chordViewMode) {
      // Roman numeral style - remove quality indicators since they're shown by case
      suffix = suffix
          .replaceAll('maj', '')
          .replaceAll('min', 'm')
          .replaceAll('m', '') // Minor is indicated by lowercase numeral
          .replaceAll('aug', '+')
          .replaceAll('dim', '°');
    } else {
      // Arabic numeral style - only show maj with extensions
      if (suffix.startsWith('maj')) {
        // Only keep 'maj' if there's more after it (e.g., maj7, maj9)
        final hasExtension = suffix.length > 3; // 'maj' is 3 characters
        suffix = hasExtension ? suffix : '';
      } else if (suffix.startsWith('min')) {
        suffix = suffix.replaceAll('min', 'm');
      } else if (suffix.startsWith('m')) {
        suffix = suffix; // keep 'm' as is
      } else if (suffix.startsWith('aug')) {
        suffix = suffix.replaceAll('aug', '+');
      } else if (suffix.startsWith('dim')) {
        suffix = suffix.replaceAll('dim', '°');
      }
    }

    return suffix;
  }

  String _convertAccidentals(String chord) {
    return chord.replaceAllMapped(
      RegExp('([A-G])([#b])'),
      (Match m) {
        final note = m.group(1)!;
        final accidental = m.group(2)!;
        final symbol = accidental == '#' ? '♯' : '♭';
        return note + symbol;
      },
    ).replaceAll('#', '♯');
  }
}
