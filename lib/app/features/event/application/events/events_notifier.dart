import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_search_type.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_filter.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_response.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventsNotifier extends _$EventsNotifier {
  final TimeUtils timeUtils = TimeUtils();
  late final EventsRepository _eventsRepository;
  static const int _pageSize = 15;

  @override
  EventsState build() {
    final dio = ref.read(dioProvider);
    _eventsRepository = EventsRepository(dio);
    return const EventsState();
  }

  Future<void> getUpcomingEvent() async {
    state = state.copyWith(isLoading: true);
    try {
      final event = await _eventsRepository.getUpcomingEvent();
      state = state.copyWith(upcomingEvent: event, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> searchEvents(String? search) async {
    state = state.copyWith(isLoading: true);
    if (search.isNullEmptyOrWhitespace) {
      state = state.copyWith(
        filteredEventsResponse: state.eventsResponse,
        isLoading: false,
      );
      return;
    }
    final eventsResponse = await _eventsRepository.getEvents(
      eventsFilter: EventsFilter(
        searchValue: search,
        limit: _pageSize,
        offset: 0,
      ),
    );

    state = state.copyWith(
      filteredEventsResponse: eventsResponse,
      isLoading: false,
    );
  }

  Future<void> getUpcomingEvents() async {
    state = state.copyWith(isLoading: true);
    try {
      final eventsResponse = await _getEvents(EventSearchType.upcoming);
      state = state.copyWith(
        upcomingEventsResponse: eventsResponse,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getPastEvents() async {
    state = state.copyWith(isLoading: true);
    try {
      final eventsResponse = await _getEvents(EventSearchType.past);
      state = state.copyWith(
        pastEventsResponse: eventsResponse,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMorePastEvents() async {
    await _loadMoreEvents(EventSearchType.past);
  }

  Future<void> loadMoreUpcomingEvents() async {
    await _loadMoreEvents(EventSearchType.upcoming);
  }

  Future<void> _loadMoreEvents(EventSearchType eventType) async {
    if (!_hasMoreEvents(eventType)) return;

    try {
      final currentEvents = _getCurrentEvents(eventType);
      final newEvents = await _getEvents(
        eventType,
        offset: currentEvents.length,
      );

      final updatedEvents = [...currentEvents, ...newEvents.events];
      state = state.copyWith(
        upcomingEventsResponse: eventType == EventSearchType.upcoming
            ? EventsResponse(events: updatedEvents, hasMore: newEvents.hasMore)
            : state.upcomingEventsResponse,
        pastEventsResponse: eventType == EventSearchType.past
            ? EventsResponse(events: updatedEvents, hasMore: newEvents.hasMore)
            : state.pastEventsResponse,
      );
    } catch (e) {}
  }

  Future<EventsResponse> _getEvents(
    EventSearchType eventType, {
    int offset = 0,
  }) async {
    return _eventsRepository.getEvents(
      eventsFilter: EventsFilter(
        limit: _pageSize,
        offset: offset,
        eventSearchType: eventType,
      ),
    );
  }

  List<EventOverview> _getCurrentEvents(EventSearchType eventType) {
    return eventType == EventSearchType.upcoming
        ? state.upcomingEventsResponse.events
        : state.pastEventsResponse.events;
  }

  bool _hasMoreEvents(EventSearchType eventType) {
    return eventType == EventSearchType.upcoming
        ? state.upcomingEventsResponse.hasMore
        : state.pastEventsResponse.hasMore;
  }
}
