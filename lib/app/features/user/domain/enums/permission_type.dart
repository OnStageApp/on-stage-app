enum PermissionType {
  SONGS_ACCESS,
  ADD_SONGS,
  SCREEEN_SYNC,
  REMINDERS,
}

extension PermissionTypeX on PermissionType {
  String get name {
    switch (this) {
      case PermissionType.SONGS_ACCESS:
        return 'songsAccess';
      case PermissionType.ADD_SONGS:
        return 'addSongs';
      case PermissionType.SCREEEN_SYNC:
        return 'screenSync';
      case PermissionType.REMINDERS:
        return 'REMINDERS';
    }
  }
}
