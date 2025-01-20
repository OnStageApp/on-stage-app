import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class MomentProfileSection extends StatelessWidget {
  const MomentProfileSection({
    required this.assignedStagers,
    required this.event,
    required this.eventItem,
    super.key,
  });

  final List<StagerOverview>? assignedStagers;
  final EventModel event;
  final EventItem eventItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (assignedStagers.isNotNullOrEmpty) ...[
          SizedBox(
            height: 64,
            width: assignedStagers != null
                ? (40 * (assignedStagers!.length - 1) + 64)
                : 64,
            child: assignedStagers != null
                ? Stack(
                    alignment: Alignment.center,
                    children: assignedStagers!
                        .asMap()
                        .entries
                        .map(
                          (entry) => Positioned(
                            left: entry.key * 40,
                            child: ProfileImageWidget(
                              name: entry.value.name!,
                              size: 64,
                              photo: entry.value.profilePicture,
                            ),
                          ),
                        )
                        .toList()
                        .reversed
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                assignedStagers
                        ?.map((stager) => stager.name ?? '')
                        .where((name) => name.isNotEmpty)
                        .join(', ') ??
                    '',
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: assignedStagers.isNotNullOrEmpty
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Badge(
              backgroundColor: context.colorScheme.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              label: Text(
                TimeUtils().calculateTime(event.dateTime, eventItem.duration),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Badge(
              backgroundColor: context.colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              label: Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    color: context.colorScheme.outline,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    TimeUtils().formatDuration(eventItem.duration),
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
