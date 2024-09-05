import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({required this.events, super.key});

  final List<EventOverview> events;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => EventTile(
            onTap: () => context.pushNamed(
              AppRoute.eventDetails.name,
              queryParameters: {'eventId': events[index].id},
            ),
            title: events[index].name ?? '',
            dateTime: events[index].dateTime?.let(DateTime.parse),
          ),
          childCount: events.length,
        ),
      ),
    );
  }
}
