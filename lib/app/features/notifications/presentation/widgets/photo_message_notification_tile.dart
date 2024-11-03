import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class PhotoMessageNotificationTile extends NotificationTile {
  const PhotoMessageNotificationTile({
    required super.notification,
    required super.onTap,
    this.profilePicture,
    super.key,
  });

  final Uint8List? profilePicture;

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.description.isNotNullEmptyOrWhitespace) ...[
                    Row(
                      children: [
                        ImageWithPlaceholder(
                          photo: profilePicture,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notification.description,
                            style: context.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Row(
                      children: [
                        Text(
                          TimeUtils().formatOnlyTime(
                            notification.dateTime ?? DateTime.now(),
                          ),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.surfaceDim,
                          ),
                        ),
                        _buildCircle(
                          context.colorScheme.outline.withOpacity(0.2),
                        ),
                        Text(
                          notification.dateTime != null
                              ? TimeUtils()
                                  .formatOnlyDate(notification.dateTime)
                              : '',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.surfaceDim,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircle(Color backgroundColor) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: backgroundColor,
      ),
    );
  }
}
