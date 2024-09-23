enum InviteStatus {
  confirmed,
  pending,
  declined,
}

//extension name

extension InviteStatusExtension on InviteStatus {
  String get name {
    switch (this) {
      case InviteStatus.confirmed:
        return 'Confirmed';
      case InviteStatus.pending:
        return 'Pending Invitation';
      case InviteStatus.declined:
        return 'Declined';
    }
  }

  static InviteStatus fromString(String value) {
    return InviteStatus.values.firstWhere(
      (inviteStatus) => inviteStatus.name == value.toLowerCase(),
      orElse: () => InviteStatus.confirmed,
    );
  }
}
