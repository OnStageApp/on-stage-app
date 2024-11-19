enum SocketEventType {
  NOTIFICATION,
  SUBSCRIPTION,
  TEAM_CHANGED,
}

// name extension
extension SocketEventTypeX on SocketEventType {
  String get name {
    switch (this) {
      case SocketEventType.NOTIFICATION:
        return 'NOTIFICATION';
      case SocketEventType.SUBSCRIPTION:
        return 'SUBSCRIPTION';
      case SocketEventType.TEAM_CHANGED:
        return 'TEAM_CHANGED';
    }
  }
}
