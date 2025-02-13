enum SocketEventType {
  NOTIFICATION,
  SUBSCRIPTION,
  TEAM_CHANGED,
  LOG_OUT,
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
      case SocketEventType.LOG_OUT:
        return 'LOG_OUT';
    }
  }
}
