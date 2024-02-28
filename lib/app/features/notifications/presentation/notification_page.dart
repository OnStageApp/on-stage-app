import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/shared/divider_widget.dart';
import 'package:on_stage_app/app/shared/custom_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifications = ref.watch(notificationNotifierProvider);
        return Scaffold(
          appBar: customAppBar(
            context,
            'Notifications',
            canBack: true,
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: notifications.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          // Apply background color only for the first item
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
                        if (index != notifications.length - 1)
                          dividerWidget(context),
                      ],
                    );
                  },
                  itemCount: notifications.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                )
              : const Center(
                  child: Text('No notifications'),
                ),
        );
      },
    );
  }
}
