class NameUtils {
  static String getInitials(String? fullName, {int maxInitials = 2}) {
    if (fullName == null || fullName.trim().isEmpty) {
      return 'UN';
    }

    final nameParts = fullName.trim().split(RegExp(r'\s+'));
    final initials = nameParts
        .take(maxInitials)
        .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
        .join('');

    return initials.isNotEmpty ? initials : 'UN';
  }
}
