enum NotificationType {
  TEAM_INVITATION_REQUEST,
  TEAM_INVITATION_ACCEPTED,
  TEAM_INVITATION_DECLINED,
  INVITATION,
}

extension NotificationTypeX on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.TEAM_INVITATION_REQUEST:
        return 'TEAM_INVITATION_REQUEST';
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        return 'TEAM_INVITATION_ACCEPTED';
      case NotificationType.TEAM_INVITATION_DECLINED:
        return 'TEAM_INVITATION_DECLINED';
      case NotificationType.INVITATION:
        return 'INVITATION';
    }
  }

  String get title {
    switch (this) {
      case NotificationType.TEAM_INVITATION_REQUEST:
        return 'Join Team';
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        return 'Team Invitation Accepted';
      case NotificationType.TEAM_INVITATION_DECLINED:
        return 'Team Invitation Declined';
      case NotificationType.INVITATION:
        return 'Invitation';
    }
  }
}
