enum SearchFilterEnum {
  all,
  bpm,
  genre,
  theme,
  artist,
}

extension SearchFilterEnumExtension on SearchFilterEnum {
  String get title {
    switch (this) {
      case SearchFilterEnum.all:
        return 'All';
      case SearchFilterEnum.bpm:
        return 'BPM';
      case SearchFilterEnum.genre:
        return 'Genre';
      case SearchFilterEnum.theme:
        return 'Theme';
      case SearchFilterEnum.artist:
        return 'Artist';
    }
  }
}
