enum TeamMemberRole {
  Leader,
  Editor,
  None,
}

extension TeamMemberRoleExtension on TeamMemberRole {
  static TeamMemberRole fromString(String value) {
    return TeamMemberRole.values.firstWhere(
      (role) => role.name == value.toLowerCase(),
      orElse: () => TeamMemberRole.None,
    );
  }
}
