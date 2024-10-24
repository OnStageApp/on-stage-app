enum PermissionType {
  songsAccess,
  addSongs,
  screenSync,
  reminders,
  addTeamMembers,
  addEvents,
  none,
}

extension PermissionTypeX on PermissionType {
  String get name {
    switch (this) {
      case PermissionType.songsAccess:
        return 'songsAccess';
      case PermissionType.addSongs:
        return 'addSongs';
      case PermissionType.screenSync:
        return 'screenSync';
      case PermissionType.reminders:
        return 'reminders';
      case PermissionType.addTeamMembers:
        return 'addTeamMembers';
      case PermissionType.addEvents:
        return 'addEvents';
      case PermissionType.none:
        return 'none';
    }
  }
}
