import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/load_more_button.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsList extends StatelessWidget {
  const EventsList({
    required this.events,
    required this.hasMore,
    required this.loadMore,
    super.key,
  });

  final List<EventOverview> events;
  final bool hasMore;
  final VoidCallback loadMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...events.map(
            (event) => EventTile(
              onTap: () => context.pushNamed(
                AppRoute.eventDetails.name,
                queryParameters: {'eventId': event.id},
              ),
              title: event.name ?? '',
              dateTime: event.dateTime?.let(DateTime.parse),
              isDraft: event.eventStatus == EventStatus.draft,
            ),
          ),
          if (hasMore) LoadMoreButton(onPressed: loadMore),
        ],
      ),
    );
  }
}
