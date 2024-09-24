import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/upcoming_event/upcoming_event_model.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/events_list_widget.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/section_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsContent extends ConsumerWidget {
  const EventsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsNotifierProvider);
    final event = eventsState.upcomingEvent;
    final upcomingEventsResponse = eventsState.upcomingEventsResponse;
    final pastEventsResponse = eventsState.pastEventsResponse;
    final upcomingIsEmpty = upcomingEventsResponse.events.isEmpty;
    final pastIsEmpty = pastEventsResponse.events.isEmpty;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnhancedEventTile(event, context),
          const SectionTitle(title: 'Upcoming Events'),
          if (!upcomingIsEmpty) ...[
            EventsList(
              events: upcomingEventsResponse.events,
              hasMore: upcomingEventsResponse.hasMore,
              loadMore: () => ref
                  .read(eventsNotifierProvider.notifier)
                  .loadMoreUpcomingEvents(),
            ),
          ] else ...[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "You don't have any upcoming events yet.",
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ),
          ],
          if (pastIsEmpty)
            const SizedBox()
          else ...[
            EventsList(
              events: pastEventsResponse.events,
              hasMore: pastEventsResponse.hasMore,
              loadMore: () => ref
                  .read(eventsNotifierProvider.notifier)
                  .loadMorePastEvents(),
            ),
            const SectionTitle(title: 'Past Events'),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedEventTile(
    UpcomingEventModel? event,
    BuildContext context,
  ) {
    return Container(
      height: 174,
      margin: const EdgeInsets.only(top: Insets.medium),
      padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
      child: EventTileEnhanced(
        isEventEmpty: event == null,
        title: event?.name ?? 'No upcoming events',
        locationName: event?.location ?? "You don't have any published events",
        dateTime: event?.dateTime,
        participantsProfileBytes: event?.stagerPhotos ?? [],
        participantsCount: event?.stagerPhotos.length ?? 0,
        onTap: () {
          if (event == null) {
            context.pushNamed(AppRoute.addEvent.name);
            return;
          }
          context.pushNamed(
            AppRoute.eventDetails.name,
            queryParameters: {'eventId': event.id},
          );
        },
      ),
    );
  }
}
