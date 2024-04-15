enum ChordViewModeEnum {
  american,
  italian,
  number,
}

extension ChordViewModeEnumValues on ChordViewModeEnum {
  String get name {
    switch (this) {
      case ChordViewModeEnum.american:
        return 'Chords';
      case ChordViewModeEnum.italian:
        return 'Chords';
      case ChordViewModeEnum.number:
        return 'Numbers';
    }
  }

  String get example {
    switch (this) {
      case ChordViewModeEnum.american:
        return 'C#';
      case ChordViewModeEnum.italian:
        return 'Do# Major';
      case ChordViewModeEnum.number:
        return 'IV';
    }
  }
}
