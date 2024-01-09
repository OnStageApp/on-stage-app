import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event/add_event_info_screen.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class EventOverviewEmpty extends ConsumerStatefulWidget {
  const EventOverviewEmpty({super.key});

  @override
  EventOverviewEmptyState createState() => EventOverviewEmptyState();
}

class EventOverviewEmptyState extends ConsumerState<EventOverviewEmpty> {
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
    return Scaffold(
      appBar: StageAppBar(
        title: 'Events',
        trailing: IconButton(
          onPressed: () {
            AddEventInfoScreen.show(context);
          },
          icon: const Icon(Icons.add),
        ),
      ),
      body: const Padding(
        padding: defaultScreenPadding,
        child: Center(
          child: Text('Add new events here!'),
        ),
      ),
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
