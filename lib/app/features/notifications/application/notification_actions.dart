// notification_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/logger.dart';

class NotificationActions {
  NotificationActions(this.ref);

  final Ref ref;

  void updateTeamInvitation(
    StageNotification notification, {
    required bool hasAccepted,
  }) {
    final teamId = notification.teamId;
    if (teamId != null) {
      ref.read(teamNotifierProvider.notifier).updateTeamInvitation(
            teamId,
            hasAccepted: hasAccepted,
          );

      ref.read(notificationNotifierProvider.notifier).updateNotification(
            notification.notificationId,
            hasAccepted
                ? NotificationActionStatus.ACCEPTED
                : NotificationActionStatus.DECLINED,
          );
    }
  }

  void goToEvent(
    StageNotification notification,
    BuildContext context,
  ) {
    final eventId = notification.eventId;
    if (eventId != null) {
      ref.read(eventNotifierProvider.notifier).getEventById(eventId);
      context.goNamed(
        AppRoute.eventDetails.name,
        queryParameters: {'eventId': eventId},
      );
    } else {
      logger.i('Event ID is null');
    }
  }

  void handleEventInvitation(
    StageNotification notification,
    StagerStatusEnum status,
    NotificationActionStatus actionStatus,
  ) {
    final eventId = notification.eventId ?? '';
    ref.read(eventNotifierProvider.notifier).setStatusForStager(
          participationStatus: status,
          eventId: eventId,
        );

    ref.read(notificationNotifierProvider.notifier).updateNotification(
          notification.notificationId,
          actionStatus,
        );
  }
}

final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});
