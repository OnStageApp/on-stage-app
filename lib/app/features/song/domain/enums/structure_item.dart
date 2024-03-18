enum StructureItem {
  V1,
  V2,
  V3,
  V4,
  V5,
  V6,
  V7,
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
}

extension StructureItemExtension on StructureItem {
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
    }
  }
}
