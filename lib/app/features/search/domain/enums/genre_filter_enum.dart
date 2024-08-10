enum GenreFilterEnum {
  jazz,
  gospel,
  worship,
  praise,
  christmas,
}

extension GenreFilterEnumExtension on GenreFilterEnum {
  String get value {
    switch (this) {
      case GenreFilterEnum.jazz:
        return 'Jazz';
      case GenreFilterEnum.gospel:
        return 'Gospel';
      case GenreFilterEnum.worship:
        return 'Worship';
      case GenreFilterEnum.praise:
        return 'Praise';
      case GenreFilterEnum.christmas:
        return 'Christmas';
    }
  }
}
