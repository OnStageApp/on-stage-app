enum PermissionType {
  SONGS_ACCESS,
  ADD_SONGS,
  SCREEEN_SYNC,
  REMINDERS,
  ADD_TEAM_MEMBERS,
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
      case PermissionType.ADD_TEAM_MEMBERS:
        return 'ADD_TEAM_MEMBERS';
    }
  }
}
