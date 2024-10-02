enum SongVersion { original, teamsVersion }

extension SongVersionExtension on SongVersion {
  String get name {
    switch (this) {
      case SongVersion.original:
        return 'Original';
      case SongVersion.teamsVersion:
        return "Team's Version";
    }
  }
}
