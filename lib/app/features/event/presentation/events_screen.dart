import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      appBar: StageAppBar(
        title: 'Events',
        trailing: Padding(
          padding: const EdgeInsets.only(right: Insets.normal),
          child: IconButton(
            onPressed: () => context.pushNamed(AppRoute.addEvent.name),
            icon: Icon(
              Icons.add,
              color: context.colorScheme.surfaceDim,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
        child: ListView(
          children: [
            const SizedBox(height: Insets.large),
            if (!eventsState.isLoading) ...[
              Text('Upcoming Events', style: context.textTheme.titleMedium),
              const SizedBox(height: Insets.normal),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: eventsState.events.length,
                  itemBuilder: (context, index) {
                    final event = eventsState.events[index];
                    return EventTileEnhanced(
                      title: event.name,
                      hour: '11:00',
                      date: 'Monday, 12th July',
                    );
                  },
                ),
              ),
              const SizedBox(height: Insets.large),
              Text('Past Events', style: context.textTheme.titleMedium),
              const SizedBox(height: Insets.normal),
              _buildAllEvents(),
            ] else ...[
              const OnStageLoadingIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return StageSearchBar(
      focusNode: FocusNode(),
      controller: searchController,
      onClosed: () {
        ref.read(eventsNotifierProvider.notifier).searchEvents('');
        _clearSearch();
      },
      onChanged: (value) {
        if (value.isEmpty) {
          _clearSearch();
        }
        ref.read(eventsNotifierProvider.notifier).searchEvents(value);
      },
    );
  }

  void _clearSearch() {
    searchController.clear();
  }

  Widget _buildAllEvents() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: ref
          .watch(eventsNotifierProvider)
          .filteredEvents
          .map(_buildEventTile)
          .toList(),
    );
  }

  Widget _buildEventTile(EventOverview event) {
    return EventTile(
      onTap: () => context.pushNamed(
        AppRoute.eventDetails.name,
        queryParameters: {'eventId': event.id},
      ),
      title: event.name,
      dateTime: DateTime.parse(event.date),
    );
  }
}
