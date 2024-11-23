enum ThemeEnum {
  others,
  forgiveness,
  love,
  praise,
  christmas,
  worship,
  hope,
  faith,
  grace,
  salvation,
  peace,
  joy,
  redemption,
  thanksgiving,
  holiness,
  trust,
  prayer,
  healing,
  resurrection,
  mercy,
}

extension ThemeEnumX on ThemeEnum {
  String get title {
    switch (this) {
      case ThemeEnum.others:
        return 'Others';
      case ThemeEnum.forgiveness:
        return 'Forgiveness';
      case ThemeEnum.love:
        return 'Love';
      case ThemeEnum.praise:
        return 'Praise';
      case ThemeEnum.christmas:
        return 'Christmas';
      case ThemeEnum.worship:
        return 'Worship';
      case ThemeEnum.hope:
        return 'Hope';
      case ThemeEnum.faith:
        return 'Faith';
      case ThemeEnum.grace:
        return 'Grace';
      case ThemeEnum.salvation:
        return 'Salvation';
      case ThemeEnum.peace:
        return 'Peace';
      case ThemeEnum.joy:
        return 'Joy';
      case ThemeEnum.redemption:
        return 'Redemption';
      case ThemeEnum.thanksgiving:
        return 'Thanksgiving';
      case ThemeEnum.holiness:
        return 'Holiness';
      case ThemeEnum.trust:
        return 'Trust';
      case ThemeEnum.prayer:
        return 'Prayer';
      case ThemeEnum.healing:
        return 'Healing';
      case ThemeEnum.resurrection:
        return 'Resurrection';
      case ThemeEnum.mercy:
        return 'Mercy';
    }
  }
}
