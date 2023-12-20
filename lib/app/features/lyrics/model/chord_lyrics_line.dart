class ChordLyricsLine {
  ChordLyricsLine()
      : chords = [],
        structure = [],
        lyrics = '';

  ChordLyricsLine.line(this.chords, this.lyrics, this.structure);
  List<Chord> chords;
  String lyrics;

  List<String> structure;

  /// Remove also the keyword
  bool isStartOfChorus() {
    const startOfChorusAbbreviation = '{soc}';
    const String startOfChorus = '{start_of_chorus}';
    var out = lyrics.contains(startOfChorus) ||
        lyrics.contains(startOfChorusAbbreviation);
    if (out) {
      lyrics = lyrics.replaceAll(startOfChorus, '');
      lyrics = lyrics.replaceAll(startOfChorusAbbreviation, '').trim();
    }
    return out;
  }

  /// Remove also the keyword
  bool isEndOfChorus() {
    const String endOfChorusAbbreviation = '{eoc}';
    const String endOfChorus = '{end_of_chorus}';
    bool out = lyrics.contains(endOfChorus) ||
        lyrics.contains(endOfChorusAbbreviation);
    if (out) {
      lyrics = lyrics.replaceAll(endOfChorus, '');
      lyrics = lyrics.replaceAll(endOfChorusAbbreviation, '').trim();
    }
    return out;
  }

  /// Remove also the keyword
  bool isComment() {
    const String comment = '{comment:';
    bool out = lyrics.contains(comment);
    if (out) {
      lyrics = lyrics.replaceAll(comment, '');
      lyrics = lyrics.replaceAll('}', '').trim();
    }
    return out;
  }

  @override
  String toString() {
    return 'ChordLyricsLine($chords, lyrics: $lyrics, structure: $structure)';
  }
}

class Chord {
  Chord(this.leadingSpace, this.chordText);
  double leadingSpace;
  String chordText;

  @override
  String toString() {
    return 'Chord(leadingSpace: $leadingSpace, chordText: $chordText)';
  }
}
