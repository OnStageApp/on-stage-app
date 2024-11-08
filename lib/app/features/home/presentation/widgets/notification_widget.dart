import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNewNotifications =
        ref.watch(notificationNotifierProvider).hasNewNotifications;
    return SizedBox(
      height: 44,
      width: 44,
      child: IconButton(
        onPressed: () => {
          context.pushNamed(
            AppRoute.notification.name,
          ),
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: hasNewNotifications
              ? Colors.white
              : context.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Insets.small),
          ),
        ),
        icon: Stack(
          children: [
            Container(
              child: Assets.icons.filledNotificationBell.svg(
                height: 16,
                width: 16,
                fit: BoxFit.fitHeight,
              ),
            ),
            if (hasNewNotifications)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
