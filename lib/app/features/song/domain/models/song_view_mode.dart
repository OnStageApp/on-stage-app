enum SongViewMode { american, lyrics, numeric }

extension SongViewModeValues on SongViewMode {
  String get name {
    switch (this) {
      case SongViewMode.american:
        return 'American Chords';
      case SongViewMode.lyrics:
        return 'Only Lyrics';
      case SongViewMode.numeric:
        return 'Numbers';
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
