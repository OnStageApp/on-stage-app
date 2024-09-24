import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class EventTileEnhanced extends StatelessWidget {
  const EventTileEnhanced({
    required this.title,
    required this.dateTime,
    required this.onTap,
    required this.locationName,
    required this.participantsProfileBytes,
    required this.participantsCount,
    this.isEventEmpty = false,
    super.key,
  });

  final String title;
  final DateTime? dateTime;
  final String? locationName;
  final bool isEventEmpty;
  final int participantsCount;
  final List<Uint8List?> participantsProfileBytes;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: context.colorScheme.secondary,
          overlayColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateTimeOnSingleEventShown(context),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
              ),
              const SizedBox(height: 6),
              Text(
                locationName ?? '',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: context.colorScheme.onSecondary,
                    ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: SizedBox(),
              ),
              if (isEventEmpty)
                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.goNamed(AppRoute.addEvent.name);
                    },
                    icon: Assets.icons.plus.svg(),
                    label: Text(
                      'Create Event',
                      style: context.textTheme.titleSmall!.copyWith(
                        color: const Color(0xFF7366FF),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                )
              else
                ParticipantsOnTile(
                  backgroundColor: context.colorScheme.onSurfaceVariant,
                  borderColor: Colors.transparent,
                  participantsProfileBytes: participantsProfileBytes,
                  participantsLength: participantsCount,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeOnSingleEventShown(BuildContext context) {
    return dateTime != null
        ? Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TimeUtils().formatOnlyTime(dateTime),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                ),
                _buildCircle(context),
                Text(
                  TimeUtils().formatOnlyDate(dateTime),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _buildCircle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 5,
        color: Color(0xFF009CC7),
      ),
    );
  }
}
