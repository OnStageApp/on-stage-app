enum SongViewMode { both, chords, lyrics }

extension SongViewModeValues on SongViewMode {
  String get name {
    switch (this) {
      case SongViewMode.both:
        return 'Both';
      case SongViewMode.chords:
        return 'Chords';
      case SongViewMode.lyrics:
        return 'Lyrics';
    }
  }

  String get example {
    switch (this) {
      case SongViewMode.chords:
        return 'C#';
      case SongViewMode.lyrics:
        return '---';
      case SongViewMode.both:
        return 'IV';
    }
  }
}

enum ChordViewMode { american, numbers, numerals }

extension ChordViewModeExtension on ChordViewMode {
  String get name {
    switch (this) {
      case ChordViewMode.american:
        return 'American';
      case ChordViewMode.numbers:
        return 'Numbers';
      case ChordViewMode.numerals:
        return 'Numerals';
    }
  }

  String get example {
    switch (this) {
      case ChordViewMode.american:
        return 'C#';
      case ChordViewMode.numbers:
        return '5/3';
      case ChordViewMode.numerals:
        return 'IV';
    }
  }
}
