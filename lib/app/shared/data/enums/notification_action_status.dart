enum NotificationActionStatus { PENDING, ACCEPTED, DECLINED, NONE }

extension NotificationActionStatusX on NotificationActionStatus {
  String get name {
    switch (this) {
      case NotificationActionStatus.PENDING:
        return 'PENDING';
      case NotificationActionStatus.ACCEPTED:
        return 'ACCEPTED';
      case NotificationActionStatus.DECLINED:
        return 'DECLINED';
      case NotificationActionStatus.NONE:
        return 'NONE';
    }
  }

  String get title {
    switch (this) {
      case NotificationActionStatus.PENDING:
        return 'Pending';
      case NotificationActionStatus.ACCEPTED:
        return 'Confirmed';
      case NotificationActionStatus.DECLINED:
        return 'Declined';
      case NotificationActionStatus.NONE:
        return 'None';
    }
  }
}
