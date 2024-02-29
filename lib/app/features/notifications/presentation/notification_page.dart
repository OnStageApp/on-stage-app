import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/shared/divider_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  late final List<StageNotification> notifications;

  @override
  Widget build(BuildContext context) {
    notifications = ref.watch(notificationNotifierProvider);
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Notifications',
        isBackButtonVisible: true,
      ),
      body: notifications.isNotEmpty
          ? _buildBody()
          : const Center(
        child: Text('No notifications'),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: notifications.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              color: index == 0
                  ? context.colorScheme.secondary.withOpacity(0.2)
                  : null,
              child: ListTile(
                title: Text(
                  notifications[index].title,
                  style: context.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  notifications[index].body,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    border: index == 0
                        ? Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/profile4.png',
                    width: 42,
                    height: 42,
                  ),
                ),
              ),
            ),
            if (index != notifications.length - 1) const DividerWidget(),
          ],
        );
      },
    );
  }
}



