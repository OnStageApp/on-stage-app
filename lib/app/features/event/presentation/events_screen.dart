import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
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
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    _isSearchedFocused();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _isSearchedFocused() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isSearching = true;
        });
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
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
            const SizedBox(height: Insets.medium),
            if (!eventsState.isLoading) ...[
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
    return Hero(
      tag: 'searchBar',
      child: StageSearchBar(
        focusNode: _focusNode,
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
      ),
    );
  }

  void _clearSearch() {
    searchController.clear();
    _focusNode.unfocus();
  }

  Widget _buildAllEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...ref.watch(eventsNotifierProvider).filteredEvents.map(
              _buildEventTile,
            ),
      ],
    );
  }

  Widget _buildEventTile(EventOverview event) {
    final formattedDate =
        DateFormat('EEEE, dd MMM').format(DateTime.parse(event.date));
    return Column(
      children: [
        EventTile(
          onTap: () => context.pushNamed(
            AppRoute.eventDetails.name,
            queryParameters: {'eventId': event.id},
          ),
          title: event.name,
          date: formattedDate,
          time: '11:00 AM',
        ),
        Divider(
          color: context.colorScheme.outlineVariant,
          thickness: 1,
          height: Insets.medium,
        ),
      ],
    );
  }
}
