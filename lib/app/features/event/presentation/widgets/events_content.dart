import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/events_list_widget.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/featured_event.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/section_tile.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsContent extends ConsumerWidget {
  const EventsContent({required this.eventsState, super.key});

  final EventsState eventsState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeaturedEvent(event: eventsState.upcomingEvent),
          if (!eventsState.isLoading) ...[
            if (!_upcomingListIsEmpty(eventsState)) ...[
              const SectionTitle(title: 'Upcoming Events'),
              EventsList(
                events: eventsState.upcomingEventsResponse.events,
                hasMore: eventsState.upcomingEventsResponse.hasMore,
                loadMore: () => ref
                    .read(eventsNotifierProvider.notifier)
                    .loadMoreUpcomingEvents(),
              ),
            ],
            const SectionTitle(title: 'Past Events'),
            if (_pastListIsEmpty(eventsState))
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "You don't have any past events yet.",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              )
            else
              EventsList(
                events: eventsState.pastEventsResponse.events,
                hasMore: eventsState.pastEventsResponse.hasMore,
                loadMore: () => ref
                    .read(eventsNotifierProvider.notifier)
                    .loadMorePastEvents(),
              ),
          ] else
            const OnStageLoadingIndicator(),
        ],
      ),
    );
  }

  bool _upcomingListIsEmpty(EventsState eventsState) {
    return eventsState.upcomingEventsResponse.events.isEmpty;
  }

  bool _pastListIsEmpty(EventsState eventsState) {
    return eventsState.pastEventsResponse.events.isEmpty;
  }
}
