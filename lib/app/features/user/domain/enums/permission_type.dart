enum PermissionType {
  addSong,
  screenSync,
  reminders,
  addTeamMembers,
  addEvents,
  none,
}

extension PermissionTypeX on PermissionType {
  String get name {
    switch (this) {
      case PermissionType.addSong:
        return 'addSong';
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

  String get paywallDescription {
    switch (this) {
      case PermissionType.reminders:
        return 'Set reminders for your events!';
      case PermissionType.addTeamMembers:
        return 'Add more team members!';
      case PermissionType.addEvents:
        return 'Add more events!';
      case PermissionType.addSong:
        return 'Add song!';
      case PermissionType.screenSync:
        return 'Screen sync!';
      case PermissionType.none:
        return 'Get Pro Features!';
    }
  }

  String get title {
    switch (this) {
      case PermissionType.reminders:
        return 'Reminders';
      case PermissionType.addTeamMembers:
        return 'Team Members';
      case PermissionType.addEvents:
        return 'Add Events';
      case PermissionType.addSong:
        return 'Add Songs';
      case PermissionType.screenSync:
        return 'Screen Sync';
      case PermissionType.none:
        return 'Upgrade to Pro';
    }
  }
}
