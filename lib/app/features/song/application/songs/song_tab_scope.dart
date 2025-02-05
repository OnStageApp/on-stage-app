enum SongTabScope { home, songs, events, profile }

extension SongTabScopeExtension on SongTabScope {
  String toName() => name;

  static SongTabScope fromName(String name) {
    return SongTabScope.values.firstWhere(
      (scope) => scope.name == name,
      orElse: () => SongTabScope.songs,
    );
  }
}
