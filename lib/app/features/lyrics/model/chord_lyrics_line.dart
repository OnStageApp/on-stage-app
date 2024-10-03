class SongLines {
  SongLines()
      : chords = [],
        lyrics = '';

  SongLines.line(this.chords, this.lyrics);

  List<Chord> chords;
  String lyrics;

  @override
  String toString() {
    return 'ChordLyricsLine($chords, lyrics: $lyrics)';
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
