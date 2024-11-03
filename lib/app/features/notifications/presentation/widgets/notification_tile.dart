import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

abstract class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final StageNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context);
}
