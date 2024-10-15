enum NotificationStatus {
  NEW,
}

extension NotificationStatusX on NotificationStatus {
  String get name {
    switch (this) {
      case NotificationStatus.NEW:
        return 'NEW';
    }
  }
}
