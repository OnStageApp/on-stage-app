enum StructureItem {
  IN,
  V1,
  V2,
  V3,
  V4,
  V5,
  V6,
  V7,
  PC,
  T,
  C,
  C1,
  C2,
  C3,
  B,
  I,
  I1,
  I2,
  I3,
  B1,
  B2,
  B3,
  E,
  none,
}

StructureItem stringToEnum(String value) {
  switch (value) {
    case 'V1':
      return StructureItem.V1;
    case 'V2':
      return StructureItem.V2;
    case 'V3':
      return StructureItem.V3;
    case 'V4':
      return StructureItem.V4;
    case 'V5':
      return StructureItem.V5;
    case 'V6':
      return StructureItem.V6;
    case 'V7':
      return StructureItem.V7;
    case 'C':
      return StructureItem.C;
    case 'C1':
      return StructureItem.C1;
    case 'C2':
      return StructureItem.C2;
    case 'C3':
      return StructureItem.C3;
    case 'B':
      return StructureItem.B;
    case 'I':
      return StructureItem.I;
    case 'I1':
      return StructureItem.I1;
    case 'I2':
      return StructureItem.I2;
    case 'I3':
      return StructureItem.I3;
    case 'B1':
      return StructureItem.B1;
    case 'B2':
      return StructureItem.B2;
    case 'B3':
      return StructureItem.B3;
    case 'E':
      return StructureItem.E;
    case 'T':
      return StructureItem.T;
    case 'PC':
      return StructureItem.PC;
    case 'IN':
      return StructureItem.IN;

    default:
      return StructureItem.none;
  }
}

extension StructureItemExtension on StructureItem {
  String toJson() => shortName;

  static StructureItem fromJson(String jsonValue) {
    return stringToEnum(jsonValue);
  }

  String get shortName {
    switch (this) {
      case StructureItem.V1:
        return 'V1';
      case StructureItem.V2:
        return 'V2';
      case StructureItem.V3:
        return 'V3';
      case StructureItem.V4:
        return 'V4';
      case StructureItem.V5:
        return 'V5';
      case StructureItem.V6:
        return 'V6';
      case StructureItem.V7:
        return 'V7';
      case StructureItem.C:
        return 'C';
      case StructureItem.C1:
        return 'C1';
      case StructureItem.C2:
        return 'C2';
      case StructureItem.C3:
        return 'C2';
      case StructureItem.B:
        return 'B';
      case StructureItem.I:
        return 'I';
      case StructureItem.I1:
        return 'I1';
      case StructureItem.I2:
        return 'I2';
      case StructureItem.I3:
        return 'I3';
      case StructureItem.B1:
        return 'B1';
      case StructureItem.B2:
        return 'B2';
      case StructureItem.B3:
        return 'B3';
      case StructureItem.E:
        return 'E';
      case StructureItem.PC:
        return 'PC';
      case StructureItem.T:
        return 'T';
      case StructureItem.IN:
        return 'IN';
      case StructureItem.none:
        return '';
    }
  }

  String get name {
    switch (this) {
      case StructureItem.V1:
        return 'Verse 1';
      case StructureItem.V2:
        return 'Verse 2';
      case StructureItem.V3:
        return 'Verse 3';
      case StructureItem.V4:
        return 'Verse 4';
      case StructureItem.V5:
        return 'Verse 5';
      case StructureItem.V6:
        return 'Verse 6';
      case StructureItem.V7:
        return 'Verse 7';
      case StructureItem.C:
        return 'Chorus';
      case StructureItem.C1:
        return 'Chorus 1';
      case StructureItem.C2:
        return 'Chorus 2';
      case StructureItem.C3:
        return 'Chorus 3';
      case StructureItem.B:
        return 'Bridge';
      case StructureItem.I:
        return 'Instrumental';
      case StructureItem.I1:
        return 'Instrumental 1';
      case StructureItem.I2:
        return 'Instrumental 2';
      case StructureItem.I3:
        return 'Instrumental 3';
      case StructureItem.B1:
        return 'Bridge 1';
      case StructureItem.B2:
        return 'Bridge 2';
      case StructureItem.B3:
        return 'Bridge 3';
      case StructureItem.E:
        return 'Ending';
      case StructureItem.PC:
        return 'Pre Chorus';
      case StructureItem.T:
        return 'Tag';
      case StructureItem.IN:
        return 'Intro';
      case StructureItem.none:
        return '';
    }
  }

  int get color {
    switch (this) {
      case StructureItem.V1:
        return 0xFFADEBFF;
      case StructureItem.V2:
        return 0xFFADEBFF;
      case StructureItem.V3:
        return 0xFFADEBFF;
      case StructureItem.V4:
        return 0xFFADEBFF;
      case StructureItem.V5:
        return 0xFFADEBFF;
      case StructureItem.V6:
        return 0xFFADEBFF;
      case StructureItem.V7:
        return 0xFFADEBFF;
      case StructureItem.C:
        return 0xFFFFC6AD;
      case StructureItem.C1:
        return 0xFFFFC6AD;
      case StructureItem.C2:
        return 0xFFFFC6AD;
      case StructureItem.C3:
        return 0xFFFFC6AD;
      case StructureItem.B:
        return 0xFF9FC6FF;
      case StructureItem.B1:
        return 0xFF9FC6FF;
      case StructureItem.B2:
        return 0xFF9FC6FF;
      case StructureItem.B3:
        return 0xFF9FC6FF;
      case StructureItem.I:
        return 0xFF9FFFA3;
      case StructureItem.I1:
        return 0xFF9FFFA3;
      case StructureItem.I2:
        return 0xFF9FFFA3;
      case StructureItem.I3:
        return 0xFF9FFFA3;
      case StructureItem.E:
        return 0xFFB29FFF;
      case StructureItem.none:
        return 0xFFB29FFF;
      case StructureItem.PC:
        return 0xFFFFB7F5;
      case StructureItem.T:
        return 0xFFFFE69F;
      case StructureItem.IN:
        return 0xFFC6FFAD;
    }
  }
}
