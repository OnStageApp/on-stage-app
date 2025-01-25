import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

/// A helper class that calculates the *diatonic chords* for a given [SongKey]
/// but **omits** any diminished chords.
class ChordsForKeyHelper {
  // The 12 semitones (no flats):
  static final List<String> _chromatic = [
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
  /// 1) All the "base" diatonic chords (I, ii, iii, IV, V, vi) or
  ///    (i, III, iv, v, VI, VII).
  /// 2) Then expansions for each chord (2, maj7, slash, etc.).
  ///
  /// For example, "C major" =>
  ///   ["C", "Dm", "Em", "F", "G", "Am",
  ///    "C2", "Cmaj7", "C/E", ..., "Dm7", ..., "Em7", ...].
  static List<String> getDiatonicChordsForKey(SongKey songKey) {
    final rootIndex = _getRootIndex(songKey.chord, songKey.isSharp);
    if (rootIndex == null) {
      return ['(No valid chord root)'];
    }

    // Are we building a major or minor scale?
    final isMajor = songKey.isMajor;
    final intervals = isMajor ? _majorScaleIntervals : _minorScaleIntervals;
    final qualities = isMajor ? _majorScaleQualities : _minorScaleQualities;

    // Collect the base chord data
    final baseChords = <_ChordData>[];
    for (var i = 0; i < intervals.length; i++) {
      final chordRootIndex = (rootIndex + intervals[i]) % 12;
      final chordQuality = qualities[i];
      final baseName = _buildBaseChordName(chordRootIndex, chordQuality);
      baseChords.add(
        _ChordData(
          name: baseName,
          rootIndex: chordRootIndex,
          quality: chordQuality,
        ),
      );
    }

    // We'll produce:
    //  a) The 6 base chords in scale
    //  b) Their expansions
    final result = <String>[];

    // a) Add base chords first
    for (final chord in baseChords) {
      result.add(chord.name);
    }

    // b) Then expansions for each
    for (final chord in baseChords) {
      final expansions = _buildExpansionsFor(chord);
      result.addAll(expansions);
    }

    return result;
  }

  /// Convert chord root + isSharp => 0..11 index in _chromatic.
  static int? _getRootIndex(ChordsWithoutSharp? chord, bool isSharp) {
    if (chord == null) return null;
    final baseIndex = _baseSemitones[chord];
    if (baseIndex == null) return null;
    return (baseIndex + (isSharp ? 1 : 0)) % 12;
  }

  /// Build the base chord name, e.g. "C", "Dm", "Em", "F", ...
  static String _buildBaseChordName(int chordRootIndex, _ChordQuality q) {
    final noteName = _chromatic[chordRootIndex];
    switch (q) {
      case _ChordQuality.major:
        return noteName; // e.g. "C"
      case _ChordQuality.minor:
        return noteName + 'm'; // e.g. "Dm"
      case _ChordQuality.dim:
        // We won't get here in this snippet because we removed dim from arrays,
        // but let's leave the switch default for safety.
        return noteName + 'dim';
    }
  }

  /// Generate expansions like "C2", "Cmaj7", "C/E" for major chords,
  /// or "Dm7", "Dm/F" for minor.
  static List<String> _buildExpansionsFor(_ChordData chord) {
    final flavors = _pickFlavors(chord.quality);
    final expansions = <String>[];

    for (final flavor in flavors) {
      expansions.add(_applyFlavor(chord, flavor));
    }
    return expansions;
  }

  /// Choose expansions based on chord quality
  static List<_ChordFlavor> _pickFlavors(_ChordQuality q) {
    switch (q) {
      case _ChordQuality.major:
        return _majorWorshipFlavors;
      case _ChordQuality.minor:
        return _minorWorshipFlavors;
      case _ChordQuality.dim:
        // We never actually hit this in the new arrays,
        // so we can safely return an empty list or whatever you prefer.
        return const [];
    }
  }

  /// Apply suffix or slash offset to the base chord name (e.g. "C" + "2" => "C2",
  /// "C" + slashOffset=7 => "C/G").
  static String _applyFlavor(_ChordData chord, _ChordFlavor flavor) {
    if (flavor.slashOffset == null) {
      // e.g. "Dm" + "7" => "Dm7"
      return chord.name + flavor.suffix;
    } else {
      final slashIndex = (chord.rootIndex + flavor.slashOffset!) % 12;
      final slashNote = _chromatic[slashIndex];
      if (flavor.suffix.isEmpty) {
        return '${chord.name}/$slashNote';
      } else {
        return '${chord.name}${flavor.suffix}/$slashNote';
      }
    }
  }
}

/// Internal data for the base chord (e.g. "Dm", rootIndex=2, minor).
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

/// Major, minor, or dim chord quality
enum _ChordQuality { major, minor, dim }

/// Additional chord "flavor" for expansions: suffix or slash offset.
class _ChordFlavor {
  final String suffix;
  final int? slashOffset;

  const _ChordFlavor({required this.suffix, this.slashOffset});
}
