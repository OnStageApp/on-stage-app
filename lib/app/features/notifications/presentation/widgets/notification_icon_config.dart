import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_type.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class NotificationIconConfig {
  const NotificationIconConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}

class NotificationIconHelper {
  static NotificationIconConfig getConfigForType(
    NotificationType type,
    BuildContext context,
  ) {
    switch (type) {
      case NotificationType.NEW_REHEARSAL:
        return NotificationIconConfig(
          icon: LucideIcons.repeat_2,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withAlpha(50),
        );

      case NotificationType.LEAD_VOICE_ASSIGNED:
        return NotificationIconConfig(
          icon: LucideIcons.mic_vocal,
          iconColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent.withAlpha(50),
        );

      case NotificationType.EVENT_DELETED:
        return NotificationIconConfig(
          icon: LucideIcons.trash,
          iconColor: Colors.red,
          backgroundColor: Colors.red.withAlpha(50),
        );

      case NotificationType.TEAM_MEMBER_REMOVED:
        return NotificationIconConfig(
          icon: LucideIcons.user_round_x,
          iconColor: Colors.red,
          backgroundColor: Colors.red.withAlpha(50),
        );

      case NotificationType.LEAD_VOICE_REMOVED:
        return NotificationIconConfig(
          icon: LucideIcons.mic_off,
          iconColor: Colors.red,
          backgroundColor: Colors.red.withAlpha(50),
        );

      case NotificationType.ROLE_CHANGED:
        return NotificationIconConfig(
          icon: LucideIcons.user_cog,
          iconColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent.withAlpha(50),
        );

      case NotificationType.TEAM_MEMBER_ADDED:
        return NotificationIconConfig(
          icon: LucideIcons.user_round_plus,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withAlpha(50),
        );

      case NotificationType.STAGER_REMOVED:
        return NotificationIconConfig(
          icon: LucideIcons.calendar_x_2,
          iconColor: context.colorScheme.error,
          backgroundColor: context.colorScheme.error.withAlpha(50),
        );

      case NotificationType.REMINDER:
        return NotificationIconConfig(
          icon: LucideIcons.calendar_sync,
          iconColor: Colors.blue,
          backgroundColor: Colors.blue.withAlpha(50),
        );
      default:
        return NotificationIconConfig(
          icon: LucideIcons.bell,
          iconColor: context.colorScheme.primary,
          backgroundColor: context.colorScheme.primary.withAlpha(50),
        );
    }
  }
}
