import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';

class SongDummy {
  static final notificationsDummy = <StageNotification>[
    //fill with dummy data
    StageNotification(
      id: 1,
      title: 'Repetitie 1',
      dateTime: DateTime(2024, 9, 11, 20, 0), // 8:00 PM
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
    StageNotification(
        id: 1,
        title: 'Friend Request',
        dateTime: DateTime(2024, 9, 20, 20, 0),
        createdAt: 'today',
        isInvitationConfirmed: false,
        seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Repetitie 2',
      dateTime: DateTime(2024, 9, 10, 15, 42), // 15:42
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
    StageNotification(
      id: 1,
      title: 'Ready to go live?',
      dateTime: DateTime(2024, 9, 22, 18, 30), // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: true,
      seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Repetitie 3',
      dateTime: DateTime(2024, 9, 5, 18, 30), // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: true,
      seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Old Notification',
      dateTime: DateTime(2024, 7, 10, 18, 30), // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
  ];


}
