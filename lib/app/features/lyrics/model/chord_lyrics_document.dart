import 'chord_lyrics_line.dart';

class ChordLyricsDocument {
  ChordLyricsDocument(
    this.chordLyricsLines, {
    this.capo,
    this.title,
    this.artist,
    this.key,
    this.structure,
  });

  final List<ChordLyricsLine> chordLyricsLines;
  final int? capo;
  final String? title;
  final String? artist;
  final String? key;

  final String? structure;
}
