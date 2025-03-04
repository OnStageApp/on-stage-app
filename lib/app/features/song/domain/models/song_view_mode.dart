enum SongViewMode { chords, lyrics, chordLyrics }

extension SongViewModeValues on SongViewMode {
  String get name {
    switch (this) {
      case SongViewMode.chords:
        return 'Chords';
      case SongViewMode.lyrics:
        return 'Lyrics';
      case SongViewMode.chordLyrics:
        return 'ChordLyrics';
    }
  }

  String get example {
    switch (this) {
      case SongViewMode.chords:
        return 'C#';
      case SongViewMode.lyrics:
        return '---';
      case SongViewMode.chordLyrics:
        return 'IV';
    }
  }
}

enum ChordsViewMode { numeric, american }

extension ChordsViewModeExtension on ChordsViewMode {
  String get name {
    switch (this) {
      case ChordsViewMode.numeric:
        return 'Numeric';
      case ChordsViewMode.american:
        return 'American';
    }
  }

  String get example {
    switch (this) {
      case ChordsViewMode.numeric:
        return 'IV';
      case ChordsViewMode.american:
        return 'C#';
    }
  }
}
