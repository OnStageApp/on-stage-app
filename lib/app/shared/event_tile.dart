import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.dateTime,
    required this.onTap,
    this.isDraft = true,
    this.participantsProfile = const [],
    this.stagersCount = 0,
    super.key,
  });

  final String title;
  final DateTime? dateTime;
  final bool isDraft;
  final VoidCallback onTap;
  final List<Uint8List?> participantsProfile;
  final int stagersCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          backgroundColor: context.colorScheme.onSurfaceVariant,
          overlayColor: context.colorScheme.outline.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        TimeUtils().formatOnlyTime(dateTime),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                      ),
                      _buildCircle(context),
                      Text(
                        dateTime != null
                            ? TimeUtils().formatOnlyDate(dateTime)
                            : '',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: context.colorScheme.surfaceDim,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isDraft)
              Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Draft',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              )
            else
              _buildParticipantsTile(context),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsTile(BuildContext context) {
    return ParticipantsOnTile(
      participantsProfileBytes: participantsProfile,
      participantsLength: stagersCount,
      backgroundColor: context.colorScheme.tertiary,
    );
  }

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: context.colorScheme.outline.withOpacity(0.2),
      ),
    );
  }
}
