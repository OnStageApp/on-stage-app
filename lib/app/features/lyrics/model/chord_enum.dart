enum ChordsWithoutSharp {
  C,
  D,
  E,
  F,
  G,
  A,
  B,
}

extension ChordsWithoutSharpExtension on ChordsWithoutSharp {
  int get value {
    switch (this) {
      case ChordsWithoutSharp.C:
        return 0;
      case ChordsWithoutSharp.D:
        return 2;
      case ChordsWithoutSharp.E:
        return 4;
      case ChordsWithoutSharp.F:
        return 5;
      case ChordsWithoutSharp.G:
        return 7;
      case ChordsWithoutSharp.A:
        return 9;
      case ChordsWithoutSharp.B:
        return 11;
    }
  }

  String get name {
    switch (this) {
      case ChordsWithoutSharp.C:
        return 'C';
      case ChordsWithoutSharp.D:
        return 'D';
      case ChordsWithoutSharp.E:
        return 'E';
      case ChordsWithoutSharp.F:
        return 'F';
      case ChordsWithoutSharp.G:
        return 'G';
      case ChordsWithoutSharp.A:
        return 'A';
      case ChordsWithoutSharp.B:
        return 'B';
    }
  }
}
