import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart'; // Assuming this is a custom loading widget
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Instead of using WidgetsBinding.instance.addPostFrameCallback, consider fetching initial data here directly or in didChangeDependencies if dependent on context.
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return eventsState.isLoading
        ? const OnStageLoadingIndicator()
        : Scaffold(
            appBar: StageAppBar(
              title: 'Events',
              trailing: IconButton(
                onPressed: () => context.pushNamed(AppRoute.addEvent.name),
                icon: const Icon(Icons.add),
              ),
            ),
            body: Padding(
              padding: defaultScreenPadding,
              child: ListView(
                children: [
                  const SizedBox(height: Insets.small),
                  _buildSearchBar(),
                  _buildEventSections(eventsState),
                ],
              ),
            ),
          );
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: 'searchBar',
      child: StageSearchBar(
        focusNode: _focusNode,
        controller: searchController,
        onClosed: () {
          if (context.canPop()) context.pop();
          searchController.clear();
        },
        onChanged: (value) =>
            ref.read(eventsNotifierProvider.notifier).searchEvents(value),
      ),
    );
  }

  Widget _buildEventSections(EventsState eventsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eventsState.thisWeekEvents.isNotEmpty)
          _buildEventsSection('This week', eventsState.thisWeekEvents),
        if (eventsState.upcomingEvents.isNotEmpty)
          _buildEventsSection('Upcoming', eventsState.upcomingEvents),
        if (eventsState.pastEvents.isNotEmpty)
          _buildEventsSection('Past Events', eventsState.pastEvents),
      ],
    );
  }

  Widget _buildEventsSection(String title, List<EventOverview> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.medium),
          child: Text(title, style: context.textTheme.titleMedium),
        ),
        ...events.map(_buildEventTile),
      ],
    );
  }

  Widget _buildEventTile(EventOverview event) {
    final formattedDate =
        DateFormat('EEEE, dd MMM').format(DateTime.parse(event.date));
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.smallNormal),
      child: GestureDetector(
        onTap: () => context.pushNamed(
          AppRoute.eventDetails.name,
          queryParameters: {'eventId': event.id},
        ),
        child: EventTile(title: event.name, description: formattedDate),
      ),
    );
  }
}
