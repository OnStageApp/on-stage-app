import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final FocusNode _focusNode = FocusNode();
  List<EventOverview> _events = List.empty(growable: true);
  List<EventOverview> _pastEvents = List.empty(growable: true);
  List<EventOverview> _thisWeekEvents = List.empty(growable: true);
  List<EventOverview> _upcomingEvents = List.empty(growable: true);
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _events = ref.watch(eventNotifierProvider).filteredEvents;
    _pastEvents = ref.watch(eventNotifierProvider).pastEvents;
    _thisWeekEvents = ref.watch(eventNotifierProvider).thisWeekEvents;
    _upcomingEvents = ref.watch(eventNotifierProvider).upcomingEvents;
    final isLoading = ref.watch(loadingProvider.notifier).state;

    return isLoading
        ? _buildLoadingIndicator()
        : Scaffold(
            appBar: StageAppBar(
              title: 'Events',
              trailing: IconButton(
                onPressed: () {
                  context.pushNamed(AppRoute.addEvent.name);
                },
                icon: const Icon(Icons.add),
              ),
            ),
            body: Padding(
              padding: defaultScreenPadding,
              child: ListView(
                children: [
                  const SizedBox(height: Insets.small),
                  Hero(
                    tag: 'searchBar',
                    child: StageSearchBar(
                      focusNode: _focusNode,
                      controller: searchController,
                      onClosed: () {
                        context.canPop() ? context.pop() : null;
                        searchController.clear();
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _focusNode.unfocus();
                        }
                        Future.delayed(const Duration(seconds: 2), () {
                          ref
                              .read(eventNotifierProvider.notifier)
                              .searchEvents(value);
                        });
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_thisWeekEvents.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Insets.medium),
                            Text(
                              'This week',
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(height: Insets.medium),
                            _buildEvents(_thisWeekEvents),
                          ],
                        ),
                      if (_upcomingEvents.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Insets.medium),
                            Text(
                              'Upcoming',
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(height: Insets.medium),
                            _buildEvents(_upcomingEvents),
                          ],
                        ),
                      if (_pastEvents.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Insets.medium),
                            Text(
                              'Past Events',
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(height: Insets.medium),
                            _buildEvents(_pastEvents),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  ListView _buildEvents(List<EventOverview> myEvents) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: myEvents.length,
      itemBuilder: (context, index) {
        final event = myEvents[index];

        final formattedDate =
            DateFormat('EEEE, dd MMM').format(DateTime.parse(event.date));

        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                final uri = API.getEvent('659d4d7e7b60a2030fff52bb');
                final response = await http.get(uri);
                var oldEvent = EventModel.fromJson(
                  jsonDecode(response.body) as Map<String, dynamic>,
                );
                await context.pushNamed(AppRoute.singleEvent.name,
                    extra: oldEvent);
              },
              child: EventTile(
                title: event.name,
                description: formattedDate,
              ),
            ),
            const SizedBox(height: Insets.smallNormal),
          ],
        );
      },
    );
  }

  Center _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
        ),
      ),
    );
  }
}
