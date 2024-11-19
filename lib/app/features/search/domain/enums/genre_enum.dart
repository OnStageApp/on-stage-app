enum GenreEnum {
  jazz,
  gospel,
  worship,
  rock,
  pop,
  hipHop,
  classical,
  country,
  reggae,
  blues,
  rnb,
  electronic,
  metal,
  funk,
  soul,
  folk,
  punk,
  latin,
}

extension GenreEnumX on GenreEnum {
  String get value {
    switch (this) {
      case GenreEnum.jazz:
        return 'Jazz';
      case GenreEnum.gospel:
        return 'Gospel';
      case GenreEnum.worship:
        return 'Worship';
      case GenreEnum.rock:
        return 'Rock';
      case GenreEnum.pop:
        return 'Pop';
      case GenreEnum.hipHop:
        return 'Hip-Hop';
      case GenreEnum.classical:
        return 'Classical';
      case GenreEnum.country:
        return 'Country';
      case GenreEnum.reggae:
        return 'Reggae';
      case GenreEnum.blues:
        return 'Blues';
      case GenreEnum.rnb:
        return 'R&B';
      case GenreEnum.electronic:
        return 'Electronic';
      case GenreEnum.metal:
        return 'Metal';
      case GenreEnum.funk:
        return 'Funk';
      case GenreEnum.soul:
        return 'Soul';
      case GenreEnum.folk:
        return 'Folk';
      case GenreEnum.punk:
        return 'Punk';
      case GenreEnum.latin:
        return 'Latin';
    }
  }
}
