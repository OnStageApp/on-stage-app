import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_icon_config.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class PhotoMessageNotificationTile extends NotificationTile {
  const PhotoMessageNotificationTile({
    required super.onTap,
    required this.status,
    this.userId,
    this.description,
    this.title,
    this.profilePicture,
    this.iconConfig,
    this.date,
    super.key,
  });

  final String? userId;
  final Uint8List? profilePicture;
  final NotificationIconConfig? iconConfig;
  final String? title;
  final String? description;
  final DateTime? date;
  final NotificationStatus status;

  Future<Uint8List?> getProfilePicture(WidgetRef ref) async {
    if (userId == null) return null;
    final teamMember =
        await ref.read(databaseProvider).getTeamMemberPhoto(userId!);
    return teamMember?.profilePicture;
  }

  @override
  Widget buildContent(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotNullEmptyOrWhitespace)
                    _buildDescriptionRow(context, ref)
                  else
                    _buildDateRow(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _buildLeadingIcon(context, ref),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description ?? '',
            style: context.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingIcon(BuildContext context, WidgetRef ref) {
    if (iconConfig != null && userId == null) {
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: iconConfig?.backgroundColor,
        ),
        child: Icon(
          iconConfig?.icon,
          size: 18,
          color: iconConfig?.iconColor,
        ),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: getProfilePicture(ref),
      builder: (context, snapshot) {
        return ImageWithPlaceholder(
          borderWidth: 0,
          photo: snapshot.data,
          placeholderColor: context.colorScheme.primary,
          backgroundColor: context.colorScheme.primary.withAlpha(50),
        );
      },
    );
  }

  Widget _buildDateRow(BuildContext context) {
    return Row(
      children: [
        Text(
          TimeUtils().formatOnlyTime(date ?? DateTime.now()),
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surfaceDim,
          ),
        ),
        _buildCircle(context.colorScheme.outline.withAlpha(50)),
        Text(
          date != null ? TimeUtils().formatOnlyDate(date) : '',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surfaceDim,
          ),
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
        size: 12,
        color: backgroundColor,
      ),
    );
  }
}
