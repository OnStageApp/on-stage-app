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
}
