class ChordLyricsLine {
  ChordLyricsLine()
      : chords = [],
        structure = '',
        lyrics = '';

  ChordLyricsLine.line(this.chords, this.lyrics, this.structure);
  List<Chord> chords;
  String lyrics;

  String structure;

  /// Remove also the keyword
  bool isStartOfChorus() {
    const startOfChorusAbbreviation = '{soc}';
    const startOfChorus = '{start_of_chorus}';
    final out = lyrics.contains(startOfChorus) ||
        lyrics.contains(startOfChorusAbbreviation);
    if (out) {
      lyrics = lyrics.replaceAll(startOfChorus, '');
      lyrics = lyrics.replaceAll(startOfChorusAbbreviation, '').trim();
    }
    return out;
  }

  /// Remove also the keyword
  bool isEndOfChorus() {
    const endOfChorusAbbreviation = '{eoc}';
    const endOfChorus = '{end_of_chorus}';
    final out = lyrics.contains(endOfChorus) ||
        lyrics.contains(endOfChorusAbbreviation);
    if (out) {
      lyrics = lyrics.replaceAll(endOfChorus, '');
      lyrics = lyrics.replaceAll(endOfChorusAbbreviation, '').trim();
    }
    return out;
  }

  /// Remove also the keyword
  bool isComment() {
    const comment = '{comment:';
    final out = lyrics.contains(comment);
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
