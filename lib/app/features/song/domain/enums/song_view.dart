enum SongViewEnum {
  american,
  lyrics,
  numeric,
}

extension SongViewEnumExtension on SongViewEnum {
  String get name {
    switch (this) {
      case SongViewEnum.american:
        return 'American';
      case SongViewEnum.lyrics:
        return 'Lyrics';
      case SongViewEnum.numeric:
        return 'Numeric';
    }
  }
}
