enum SocketEventType {
  notification,
  subscription,
}

// name extension
extension SocketEventTypeX on SocketEventType {
  String get name {
    switch (this) {
      case SocketEventType.notification:
        return 'NOTIFICATION';
      case SocketEventType.subscription:
        return 'SUBSCRIPTION';
    }
  }
}
