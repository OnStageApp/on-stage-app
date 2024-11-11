// notification_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
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
    final teamMemberId = notification.params?.teamMemberId;
    if (teamMemberId != null) {
      ref.read(teamMembersNotifierProvider.notifier).updateTeamMemberInvitation(
            teamMemberId,
            inviteStatus:
                hasAccepted ? InviteStatus.confirmed : InviteStatus.declined,
          );

      ref.read(notificationNotifierProvider.notifier).updateNotification(
            notification.notificationId,
            notification.status ?? NotificationStatus.VIEWED,
            hasAccepted
                ? NotificationActionStatus.ACCEPTED
                : NotificationActionStatus.DECLINED,
          );
    }
  }

  void goToEvent(
    String? eventId,
    BuildContext context,
  ) {
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
    final stagerId = notification.params?.stagerId;
    if (stagerId == null) return;
    ref.read(eventNotifierProvider.notifier).setStatusForStager(
          participationStatus: status,
          stagerId: stagerId,
        );

    ref.read(notificationNotifierProvider.notifier).updateNotification(
          notification.notificationId,
          notification.status ?? NotificationStatus.VIEWED,
          actionStatus,
        );
  }
}

final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});
