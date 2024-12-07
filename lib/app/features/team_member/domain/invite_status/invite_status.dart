enum InviteStatus { confirmed, pending, declined, inactive }

extension InviteStatusExtension on InviteStatus {
  String get name {
    switch (this) {
      case InviteStatus.confirmed:
        return 'Confirmed';
      case InviteStatus.pending:
        return 'Pending...';
      case InviteStatus.declined:
        return 'Declined';
      case InviteStatus.inactive:
        return 'Inactive';
    }
  }

  static InviteStatus fromString(String value) {
    return InviteStatus.values.firstWhere(
      (inviteStatus) => inviteStatus.name == value.toLowerCase(),
      orElse: () => InviteStatus.confirmed,
    );
  }
}
