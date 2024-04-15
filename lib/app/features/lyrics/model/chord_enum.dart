enum ChordEnum {
  C,
  C_SHARP,
  D,
  D_SHARP,
  E,
  F,
  F_SHARP,
  G,
  G_SHARP,
  A,
  A_SHARP,
  B,
}

extension ChordExtension on ChordEnum {
  String get name {
    switch (this) {
      case ChordEnum.C:
        return 'C';
      case ChordEnum.C_SHARP:
        return 'C#';
      case ChordEnum.D:
        return 'D';
      case ChordEnum.D_SHARP:
        return 'D#';
      case ChordEnum.E:
        return 'E';
      case ChordEnum.F:
        return 'F';
      case ChordEnum.F_SHARP:
        return 'F#';
      case ChordEnum.G:
        return 'G';
      case ChordEnum.G_SHARP:
        return 'G#';
      case ChordEnum.A:
        return 'A';
      case ChordEnum.A_SHARP:
        return 'A#';
      case ChordEnum.B:
        return 'B';
    }
  }
}

enum ChordsEnum {
  C,
  D,
  E,
  F,
  G,
  A,
  B,
}

extension ChordWithoutSharpExtension on ChordsEnum {
  int get value {
    switch (this) {
      case ChordsEnum.C:
        return 0;
      case ChordsEnum.D:
        return 2;
      case ChordsEnum.E:
        return 4;
      case ChordsEnum.F:
        return 5;
      case ChordsEnum.G:
        return 7;
      case ChordsEnum.A:
        return 9;
      case ChordsEnum.B:
        return 11;
    }
  }

  String get name {
    switch (this) {
      case ChordsEnum.C:
        return 'C';
      case ChordsEnum.D:
        return 'D';
      case ChordsEnum.E:
        return 'E';
      case ChordsEnum.F:
        return 'F';
      case ChordsEnum.G:
        return 'G';
      case ChordsEnum.A:
        return 'A';
      case ChordsEnum.B:
        return 'B';
    }
  }
}
