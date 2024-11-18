enum NotificationType {
  TEAM_INVITATION_REQUEST,
  TEAM_INVITATION_ACCEPTED,
  TEAM_INVITATION_DECLINED,
  EVENT_INVITATION_REQUEST,
  EVENT_INVITATION_ACCEPTED,
  EVENT_INVITATION_DECLINED,
  NEW_REHEARSAL,
  LEAD_VOICE_ASSIGNED,
  EVENT_DELETED,
  TEAM_MEMBER_REMOVED,
  LEAD_VOICE_REMOVED,
  ROLE_CHANGED,
  TEAM_MEMBER_ADDED,
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
      case NotificationType.EVENT_INVITATION_REQUEST:
        return 'EVENT_INVITATION_REQUEST';
      case NotificationType.EVENT_INVITATION_ACCEPTED:
        return 'EVENT_INVITATION_ACCEPTED';
      case NotificationType.EVENT_INVITATION_DECLINED:
        return 'EVENT_INVITATION_DECLINED';

      case NotificationType.NEW_REHEARSAL:
        return 'NEW_REHEARSAL';
      case NotificationType.LEAD_VOICE_ASSIGNED:
        return 'LEAD_VOICE_ASSIGNED';
      case NotificationType.EVENT_DELETED:
        return 'EVENT_DELETED';
      case NotificationType.TEAM_MEMBER_REMOVED:
        return 'TEAM_MEMBER_REMOVED';
      case NotificationType.LEAD_VOICE_REMOVED:
        return 'LEAD_VOICE_REMOVED';
      case NotificationType.ROLE_CHANGED:
        return 'ROLE_CHANGED';
      case NotificationType.TEAM_MEMBER_ADDED:
        return 'TEAM_MEMBER_ADDED';
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
      case NotificationType.EVENT_INVITATION_REQUEST:
        return 'Event Invitation';
      case NotificationType.EVENT_INVITATION_ACCEPTED:
        return 'Event Invitation Accepted';
      case NotificationType.EVENT_INVITATION_DECLINED:
        return 'Event Invitation Declined';
      case NotificationType.NEW_REHEARSAL:
        return 'New Rehearsal';
      case NotificationType.LEAD_VOICE_ASSIGNED:
        return 'Lead Voice Assigned';
      case NotificationType.EVENT_DELETED:
        return 'Event Deleted';
      case NotificationType.TEAM_MEMBER_REMOVED:
        return 'Team Member Removed';
      case NotificationType.LEAD_VOICE_REMOVED:
        return 'Lead Voice Removed';
      case NotificationType.ROLE_CHANGED:
        return 'Role Changed';
      case NotificationType.TEAM_MEMBER_ADDED:
        return 'Team Member Added';
    }
  }
}
