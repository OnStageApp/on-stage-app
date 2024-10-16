enum NotificationStatus {
  NEW,
  VIEWED,
}

extension NotificationStatusX on NotificationStatus {
  String get name {
    switch (this) {
      case NotificationStatus.NEW:
        return 'NEW';
      case NotificationStatus.VIEWED:
        return 'VIEWED';
    }
  }
}
