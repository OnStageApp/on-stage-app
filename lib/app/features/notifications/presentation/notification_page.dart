import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationNotifierProvider);
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Notifications',
        isBackButtonVisible: true,
      ),
      body: notifications.isNotEmpty
          ? SingleChildScrollView(child: _buildBody(notifications, context))
          : const Center(child: Text('No notifications')),
    );
  }

  Widget _buildBody(
      List<StageNotification> notifications, BuildContext context) {
    final unconfirmedInvitations =
    notifications.where((n) => !n.isInvitationConfirmed).toList();
    final confirmedInvitations =
    notifications.where((n) => n.isInvitationConfirmed).toList();
    final lastWeekInvitations = _getLastWeekInvitations(confirmedInvitations);

    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(context, 'Unread', lastWeekInvitations),
          // _buildSection(context, 'Upcoming', confirmedInvitations),
          _buildSection(context, 'Last Week', unconfirmedInvitations),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title,
      List<StageNotification> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        _buildInvitationList(notifications),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInvitationList(List<StageNotification> notifications) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final leftTime = _getLeftTime(notification.dateTime);

        return EventTile(
          title: notification.title,
          dateTime: notification.dateTime,
          onTap: () {},
          isInvitationConfirmed: notification.isInvitationConfirmed,
          isNotification: true,
          leftTime: leftTime,
        );
      },
    );
  }

  List<StageNotification> _getLastWeekInvitations(
      List<StageNotification> notifications) {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    return notifications.where((n) => n.dateTime.isAfter(oneWeekAgo)).toList();
  }

  String _getLeftTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;

    if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1) {
      return 'Event in $difference days';
    } else {
      return 'Event today';
    }
  }
}

