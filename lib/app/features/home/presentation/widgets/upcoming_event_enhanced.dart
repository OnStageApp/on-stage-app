import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/create_event_adaptive_menu.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class UpcomingEventEnhanced extends ConsumerWidget {
  const UpcomingEventEnhanced({
    required this.title,
    required this.hour,
    required this.date,
    required this.hasUpcomingEvent,
    required this.onTap,
    required this.stagerPhotos,
    required this.stagerCount,
    this.location,
    super.key,
  });

  final String title;
  final String hour;
  final String date;
  final String? location;
  final bool hasUpcomingEvent;
  final List<Uint8List?> stagerPhotos;
  final int stagerCount;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: hasUpcomingEvent ? onTap : null,
      overlayColor: WidgetStateProperty.all(const Color(0x33FFFFFF)),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: hasUpcomingEvent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Upcoming',
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: Insets.medium),
                  AutoSizeText(
                    title,
                    style: context.textTheme.headlineLarge!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          hour,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.onSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildCircle(context),
                      Flexible(
                        child: AutoSizeText(
                          date,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.onSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ParticipantsOnTile(
                        backgroundColor: context.colorScheme.onSurface,
                        borderColor: context.colorScheme.tertiary,
                        textColor: context.colorScheme.onSurfaceVariant,
                        participantsProfileBytes: stagerPhotos,
                        participantsLength: stagerCount,
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No upcoming events',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    if (ref.watch(permissionServiceProvider).hasAccessToEdit)
                      CreateEventAdaptiveMenu(
                        width: 150,
                        height: 32,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.plus,
                                color: context.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AutoSizeText(
                                  'Create Event',
                                  style: context.textTheme.titleSmall!.copyWith(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
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
