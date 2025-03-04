import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/chord_type_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

/// A helper class that calculates the *diatonic chords* for a given [SongKey]
/// but **omits** any diminished chords.
class ChordsForKeyHelper {
  // Base semitones for "natural" chord letters (no sharp).
  static final Map<ChordsWithoutSharp, int> _baseSemitones = {
    ChordsWithoutSharp.C: 0,
    ChordsWithoutSharp.D: 2,
    ChordsWithoutSharp.E: 4,
    ChordsWithoutSharp.F: 5,
    ChordsWithoutSharp.G: 7,
    ChordsWithoutSharp.A: 9,
    ChordsWithoutSharp.B: 11,
  };

  // Major scale intervals without the vii° chord (so 6 total).
  // I, ii, iii, IV, V, vi
  static final List<int> _majorScaleIntervals = [0, 2, 4, 5, 7, 9];
  static final List<_ChordQuality> _majorScaleQualities = [
    _ChordQuality.major, // I
    _ChordQuality.minor, // ii
    _ChordQuality.minor, // iii
    _ChordQuality.major, // IV
    _ChordQuality.major, // V
    _ChordQuality.minor, // vi
  ];

  // Natural minor intervals without the ii° chord (so 6 total):
  // i, III, iv, v, VI, VII
  static final List<int> _minorScaleIntervals = [0, 3, 5, 7, 8, 10];
  static final List<_ChordQuality> _minorScaleQualities = [
    _ChordQuality.minor, // i
    _ChordQuality.major, // III
    _ChordQuality.minor, // iv
    _ChordQuality.minor, // v
    _ChordQuality.major, // VI
    _ChordQuality.major, // VII
  ];

  /// Expansions for major chords: "C" -> "C2", "Cmaj7", "C/E", etc.
  static final List<_ChordFlavor> _majorWorshipFlavors = [
    _ChordFlavor(suffix: '2'),
    _ChordFlavor(suffix: 'maj7'),
    _ChordFlavor(suffix: '7'),
    _ChordFlavor(suffix: 'sus'),
    // slash offsets: 4 => major 3rd, 7 => perfect 5th
    _ChordFlavor(suffix: '', slashOffset: 4),
    _ChordFlavor(suffix: '', slashOffset: 7),
  ];

  /// Expansions for minor chords: "Dm" -> "Dm7", "Dm/F", etc.
  static final List<_ChordFlavor> _minorWorshipFlavors = [
    _ChordFlavor(suffix: '7'),
    _ChordFlavor(suffix: 'sus'),
    // 3 => minor 3rd slash, 7 => perfect 5th slash
    _ChordFlavor(suffix: '', slashOffset: 3),
    _ChordFlavor(suffix: '', slashOffset: 7),
  ];

  /// Main method: returns a list of diatonic chords for [songKey], skipping dim.
  static List<String> getDiatonicChordsForKey(SongKey songKey) {
    final rootIndex = _getRootIndex(songKey.chord, songKey.keyType);
    if (rootIndex == null) {
      return ['(No valid chord root)'];
    }

    final isMajor = songKey.isMajor;
    final intervals = isMajor ? _majorScaleIntervals : _minorScaleIntervals;
    final qualities = isMajor ? _majorScaleQualities : _minorScaleQualities;

    final baseChords = <_ChordData>[];
    for (var i = 0; i < intervals.length; i++) {
      final chordRootIndex = (rootIndex + intervals[i]) % 12;
      final chordQuality = qualities[i];
      final baseName = _buildBaseChordName(
        chordRootIndex,
        chordQuality,
        preferFlat: songKey.keyType == ChordTypeEnum.flat,
      );
      baseChords.add(
        _ChordData(
          name: baseName,
          rootIndex: chordRootIndex,
          quality: chordQuality,
        ),
      );
    }

    final result = <String>[];

    // Add base chords first
    for (final chord in baseChords) {
      result.add(chord.name);
    }

    // Then expansions for each
    for (final chord in baseChords) {
      final expansions = _buildExpansionsFor(
        chord,
        preferFlat: songKey.keyType == ChordTypeEnum.flat,
      );
      result.addAll(expansions);
    }

    return result;
  }

  static int? _getRootIndex(
    ChordsWithoutSharp? chord,
    ChordTypeEnum chordType,
  ) {
    if (chord == null) return null;
    final baseIndex = _baseSemitones[chord];
    if (baseIndex == null) return null;

    return switch (chordType) {
      ChordTypeEnum.sharp => (baseIndex + 1) % 12,
      ChordTypeEnum.flat => (baseIndex - 1 + 12) % 12,
      ChordTypeEnum.natural => baseIndex,
    };
  }

  static String _buildBaseChordName(
    int chordRootIndex,
    _ChordQuality q, {
    bool preferFlat = false,
  }) {
    final noteName = _getSemitoneName(chordRootIndex, preferFlat: preferFlat);

    return switch (q) {
      _ChordQuality.major => noteName,
      _ChordQuality.minor => '${noteName}m',
      _ChordQuality.dim => '${noteName}dim',
    };
  }

  static String _getSemitoneName(int semitone, {bool preferFlat = false}) {
    return switch (semitone) {
      0 => 'C',
      1 => preferFlat ? 'Db' : 'C#',
      2 => 'D',
      3 => preferFlat ? 'Eb' : 'D#',
      4 => 'E',
      5 => 'F',
      6 => preferFlat ? 'Gb' : 'F#',
      7 => 'G',
      8 => preferFlat ? 'Ab' : 'G#',
      9 => 'A',
      10 => preferFlat ? 'Bb' : 'A#',
      11 => 'B',
      _ => 'C', // fallback
    };
  }

  static List<String> _buildExpansionsFor(_ChordData chord,
      {bool preferFlat = false}) {
    final flavors = _pickFlavors(chord.quality);
    final expansions = <String>[];

    for (final flavor in flavors) {
      expansions.add(_applyFlavor(chord, flavor, preferFlat: preferFlat));
    }
    return expansions;
  }

  static List<_ChordFlavor> _pickFlavors(_ChordQuality q) {
    return switch (q) {
      _ChordQuality.major => _majorWorshipFlavors,
      _ChordQuality.minor => _minorWorshipFlavors,
      _ChordQuality.dim => const [],
    };
  }

  static String _applyFlavor(
    _ChordData chord,
    _ChordFlavor flavor, {
    bool preferFlat = false,
  }) {
    if (flavor.slashOffset == null) {
      return chord.name + flavor.suffix;
    }

    final slashIndex = (chord.rootIndex + flavor.slashOffset!) % 12;
    final slashNote = _getSemitoneName(slashIndex, preferFlat: preferFlat);

    return flavor.suffix.isEmpty
        ? '${chord.name}/$slashNote'
        : '${chord.name}${flavor.suffix}/$slashNote';
  }
}

class _ChordData {
  final String name;
  final int rootIndex;
  final _ChordQuality quality;

  const _ChordData({
    required this.name,
    required this.rootIndex,
    required this.quality,
  });
}

enum _ChordQuality { major, minor, dim }

class _ChordFlavor {
  final String suffix;
  final int? slashOffset;

  const _ChordFlavor({required this.suffix, this.slashOffset});
}
