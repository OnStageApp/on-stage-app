enum SongViewMode { american, lyrics, numeric }

extension SongViewModeValues on SongViewMode {
  String get name {
    switch (this) {
      case SongViewMode.american:
        return 'Chords';
      case SongViewMode.lyrics:
        return 'Lyrics';
      case SongViewMode.numeric:
        return 'Numeric';
    }
  }

  String get example {
    switch (this) {
      case SongViewMode.american:
        return 'C#';
      case SongViewMode.lyrics:
        return '---';
      case SongViewMode.numeric:
        return 'IV';
    }
  }
}
