import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class UpcomingEventEnhanced extends StatelessWidget {
  const UpcomingEventEnhanced({
    required this.title,
    required this.hour,
    required this.date,
    required this.hasUpcomingEvent,
    required this.onTap,
    this.location,
    super.key,
  });

  final String title;
  final String hour;
  final String date;
  final String? location;
  final bool hasUpcomingEvent;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: hasUpcomingEvent ? onTap : null,
      overlayColor: WidgetStateProperty.all(const Color(0x33FFFFFF)),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
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
                  Text(
                    title,
                    style: context.textTheme.headlineLarge!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Insets.medium),
                  Row(
                    children: [
                      Text(
                        hour,
                        style: context.textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.onSecondary,
                        ),
                      ),
                      _buildCircle(context),
                      Text(
                        date,
                        style: context.textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ParticipantsOnTile(
                        backgroundColor: Colors.white,
                        borderColor: Colors.transparent,
                        participantsProfile: [
                          'assets/images/profile1.png',
                          'assets/images/profile2.png',
                          'assets/images/profile4.png',
                          'assets/images/profile5.png',
                          'assets/images/profile5.png',
                          'assets/images/profile5.png',
                          'assets/images/profile5.png',
                          'assets/images/profile5.png',
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'No upcoming events',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(
                      width: double.infinity,
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
