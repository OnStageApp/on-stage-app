import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_list.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationNotifierProvider.notifier).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationNotifierProvider);
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Notifications',
        trailing: SettingsTrailingAppBarButton(onTap: () {}),
      ),
      body: notifications.isNotEmpty
          ? Padding(
              padding: defaultScreenHorizontalPadding,
              child: NotificationList(notifications: notifications),
            )
          : const Center(child: Text('No notifications')),
    );
  }
}
