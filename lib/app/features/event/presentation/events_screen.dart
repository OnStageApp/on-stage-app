import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/format_event_date.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final FocusNode _focusNode = FocusNode();
  List<EventModel> _events = List.empty(growable: true);
  List<EventModel> _pastEvents = List.empty(growable: true);
  List<EventModel> _thisWeekEvents = List.empty(growable: true);
  List<EventModel> _upcomingEvents = List.empty(growable: true);
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
      appBar: const StageAppBar(
        title: 'Events',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            const SizedBox(height: Insets.medium),
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

  ListView _buildEvents(List<EventModel> myEvents) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: myEvents.length,
      itemBuilder: (context, index) {
        final event = myEvents[index];

        return Column(
          children: [
            EventTile(
              title: event.name,
              description: formatEventDate(event.date),
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
