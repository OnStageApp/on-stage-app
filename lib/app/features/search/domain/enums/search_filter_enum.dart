enum SearchFilterEnum {
  all,
  tempo,
  genre,
  theme,
  artist,
  team,
}

extension SearchFilterEnumExtension on SearchFilterEnum {
  String get title {
    switch (this) {
      case SearchFilterEnum.all:
        return 'All';
      case SearchFilterEnum.tempo:
        return 'BPM';
      case SearchFilterEnum.genre:
        return 'Genre';
      case SearchFilterEnum.theme:
        return 'Theme';
      case SearchFilterEnum.artist:
        return 'Artist';
      case SearchFilterEnum.team:
        return 'Song Library';
    }
  }
}
