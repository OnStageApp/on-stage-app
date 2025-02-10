import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_switch_team_button.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/data/enums/notification_action_status.dart';
import 'package:on_stage_app/app/shared/invite_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class TeamActionNotificationTile extends NotificationTile {
  const TeamActionNotificationTile({
    required super.onTap,
    required this.notification,
    super.key,
    this.onDecline,
    this.onConfirm,
  });

  final void Function()? onDecline;
  final void Function()? onConfirm;
  final StageNotification notification;

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildActionButtons(context, ref),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildNotificationInfo(context),
        ),
        if (_shouldShowPositionBadge) _buildPositionBadge(context),
      ],
    );
  }

  Widget _buildNotificationInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 6),
        _buildInviteText(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        if (notification.status == NotificationStatus.NEW)
          _NewNotificationIndicator(color: context.colorScheme.error),
        Expanded(
          child: Text(
            notification.title ?? 'Notification',
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInviteText(BuildContext context) {
    return Text(
      'You have been invited to join ${notification.title ?? ''} team',
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.surfaceDim,
      ),
    );
  }

  Widget _buildPositionBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        notification.params?.positionName ?? '',
        style: context.textTheme.titleSmall,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionButtonSection(
            notification: notification,
            onDecline: onDecline,
            onConfirm: onConfirm,
            currentTeamId: ref.watch(teamNotifierProvider).currentTeam?.id,
          ),
        ),
      ],
    );
  }

  Color _getBadgeColor(BuildContext context) {
    return context.isDarkMode
        ? context.colorScheme.surfaceContainerHigh.withOpacity(0.5)
        : context.colorScheme.surface;
  }

  bool get _shouldShowPositionBadge =>
      notification.params?.positionName.isNotNullEmptyOrWhitespace ?? false;
}

class _NewNotificationIndicator extends StatelessWidget {
  const _NewNotificationIndicator({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 12,
        color: color,
      ),
    );
  }
}

class _ActionButtonSection extends StatelessWidget {
  const _ActionButtonSection({
    required this.notification,
    required this.currentTeamId,
    this.onDecline,
    this.onConfirm,
  });

  final StageNotification notification;
  final String? currentTeamId;
  final VoidCallback? onDecline;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    if (notification.actionStatus == NotificationActionStatus.PENDING) {
      return _buildPendingActions();
    }

    return _buildCompletedAction();
  }

  Widget _buildPendingActions() {
    return Row(
      children: [
        Expanded(
          child: InviteButton(
            text: 'Decline',
            onPressed: onDecline ?? () {},
            isConfirm: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InviteButton(
            text: 'Confirm',
            onPressed: onConfirm ?? () {},
            isConfirm: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedAction() {
    if (notification.actionStatus == NotificationActionStatus.DECLINED) {
      return const InviteButton(
        text: 'Declined',
        isConfirm: false,
      );
    } else if (notification.actionStatus == NotificationActionStatus.DISABLED) {
      return const Text('No longer available');
    }

    if (currentTeamId != notification.params?.teamId) {
      return NotificationSwitchTeamButton(
        text: 'Switch Team',
        textColor: Colors.blue,
        backgroundColor: Colors.blue.withAlpha(60),
        teamId: notification.params?.teamId,
      );
    }

    return const InviteButton(
      text: 'Joined',
      isConfirm: true,
    );
  }
}
