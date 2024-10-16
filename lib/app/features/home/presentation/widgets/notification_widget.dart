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
    return IconButton(
      onPressed: () => {
        context.pushNamed(
          AppRoute.notification.name,
        ),
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(Insets.smallNormal),
        backgroundColor:
            ref.watch(notificationNotifierProvider).notifications.isNotEmpty
                ? context.colorScheme.onSurfaceVariant
                : const Color(0xFFE2E2E5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.small),
        ),
      ),
      icon: Stack(
        children: [
          Assets.icons.filledNotificationBell.svg(
            height: 20,
            width: 20,
          ),
          if (ref.watch(notificationNotifierProvider).notifications.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
