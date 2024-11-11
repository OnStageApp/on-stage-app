enum TeamMemberRole {
  leader,
  editor,
  none,
}

extension TeamMemberRoleExtension on TeamMemberRole {
  static TeamMemberRole fromString(String value) {
    return TeamMemberRole.values.firstWhere(
      (role) => role.name == value.toLowerCase(),
      orElse: () => TeamMemberRole.none,
    );
  }

  String get title {
    switch (this) {
      case TeamMemberRole.leader:
        return 'Leader';
      case TeamMemberRole.editor:
        return 'Editor';
      case TeamMemberRole.none:
        return 'None';
    }
  }
}
