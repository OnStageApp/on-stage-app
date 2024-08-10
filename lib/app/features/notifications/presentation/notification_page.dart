import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationNotifierProvider);
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Notifications',
        trailing: SettingsTrailingAppBarButton(
          onTap: () {}
        ),
      ),
      body: notifications.isNotEmpty
          ? SingleChildScrollView(child: _buildBody(notifications, context))
          : const Center(child: Text('No notifications')),
    );
  }

  Widget _buildBody(
      List<StageNotification> notifications, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final oneWeekAgo = today.subtract(const Duration(days: 7));
    final oneMonthAgo = today.subtract(const Duration(days: 30));

    final Map<String, List<StageNotification>> categorizedNotifications = {
      'New': notifications.where((n) => n.dateTime.isAfter(today)).toList(),
      'Last 7 days': notifications
          .where(
            (n) => n.dateTime.isAfter(oneWeekAgo) && n.dateTime.isBefore(today)
          )
          .toList(),
      'Last 30 days':
          notifications.where((n) => n.dateTime.isBefore(oneMonthAgo)).toList(),
    };

    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categorizedNotifications.entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => _buildSection(context, entry.key, entry.value))
            .toList(),
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
        final isNotificationNew = notification.dateTime
            .isAfter(DateTime.now().subtract(const Duration(days: 1)));

        return EventTile(
          title: notification.title,
          dateTime: notification.dateTime,
          onTap: () {},
          isNotificationHasActionButtons: notification.isInvitationConfirmed,
          isNotification: true,
          leftTime: leftTime,
          isNotificationNew: isNotificationNew,
        );
      },
    );
  }

  String _getLeftTime(DateTime dateTime) {
    final difference = dateTime.difference(DateTime.now()).inDays;

    if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1) {
      return 'Event in $difference days';
    } else {
      return 'Event today';
    }
  }
}
