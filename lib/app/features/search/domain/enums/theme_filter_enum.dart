enum ThemeFilterEnum {
  all,
  forgiveness,
  love,
  praise,
  christmas,
}

extension ThemeFilterEnumExtension on ThemeFilterEnum {
  String get value {
    switch (this) {
      case ThemeFilterEnum.all:
        return 'All';
      case ThemeFilterEnum.forgiveness:
        return 'Forgiveness';
      case ThemeFilterEnum.love:
        return 'Love';
      case ThemeFilterEnum.praise:
        return 'Praise';
      case ThemeFilterEnum.christmas:
        return 'Christmas';
    }
  }
}
