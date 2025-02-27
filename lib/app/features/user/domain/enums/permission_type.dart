enum PermissionType {
  addSong,
  screenSync,
  reminders,
  addTeamMembers,
  addEvents,
  songFileStorage,
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
      case PermissionType.songFileStorage:
        return 'songFileStorage';
      case PermissionType.none:
        return 'none';
    }
  }

  String get paywallDescription {
    switch (this) {
      case PermissionType.reminders:
        return 'Set reminders for your events!';
      case PermissionType.addTeamMembers:
        return 'Step up, discover more!';
      case PermissionType.addEvents:
        return 'Step up, discover more!';
      case PermissionType.addSong:
        return 'Explore more by upgrading';
      case PermissionType.screenSync:
        return 'Step up, discover more!';
      case PermissionType.songFileStorage:
        return 'Upgrade your storage limit!';
      case PermissionType.none:
        return 'Step up, discover more!';
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
      case PermissionType.songFileStorage:
        return 'Storage Limit Exceeded';
      case PermissionType.none:
        return 'Upgrade to Pro';
    }
  }

  String paywallImage({required bool isDarkMode}) {
    switch (this) {
      case PermissionType.reminders:
        return isDarkMode
            ? 'assets/images/paywall_reminders_dark.png'
            : 'assets/images/paywall_reminders_light.png';
      case PermissionType.addTeamMembers:
        return isDarkMode
            ? 'assets/images/paywall_team_members_dark.png'
            : 'assets/images/paywall_team_members_light.png';
      case PermissionType.addEvents:
        return isDarkMode
            ? 'assets/images/paywall_add_events_dark.png'
            : 'assets/images/paywall_add_events_light.png';
      case PermissionType.addSong:
        return isDarkMode
            ? 'assets/images/paywall_add_song_dark.png'
            : 'assets/images/paywall_add_song_light.png';
      case PermissionType.screenSync:
        return isDarkMode
            ? 'assets/images/screen_sync_dark.png'
            : 'assets/images/screen_sync_light.png';
      case PermissionType.songFileStorage:
        return isDarkMode
            ? 'assets/images/paywall_storage_dark.png'
            : 'assets/images/paywall_storage_light.png';
      case PermissionType.none:
        return isDarkMode
            ? 'assets/images/upgrade_dark.png'
            : 'assets/images/upgrade_light.png';
    }
  }
}
