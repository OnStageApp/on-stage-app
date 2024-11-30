import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_search_type.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_filter.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_response.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@Riverpod()
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

  void resetState() {
    state = const EventsState();
  }

  Future<void> initEvents() async {
    state = state.copyWith(isLoading: true);
    await Future.wait([
      getUpcomingEvents(),
      getPastEvents(),
      getUpcomingEvent(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  Future<void> resetEvents() async {
    state = const EventsState();
  }

  Future<void> getUpcomingEvent() async {
    try {
      final event = await _eventsRepository.getUpcomingEvent();

      if (event == null) {
        final eventsState = EventsState(
          upcomingEventsResponse: state.upcomingEventsResponse,
          pastEventsResponse: state.pastEventsResponse,
          isLoading: state.isLoading,
        );
        state = eventsState;
      } else if (event.userIdsWithPhoto == null) {
        state = state.copyWith(upcomingEvent: event);
      } else {
        final photos =
            await _setPhotosFromLocalStorage(event.userIdsWithPhoto ?? []);
        final newEvent = event.copyWith(stagerPhotos: photos);
        state = state.copyWith(upcomingEvent: newEvent);
      }
    } on DioException catch (e, s) {
      logger.e('Error getting upcoming event (DioException): $e $s');
    } catch (e) {
      logger.e('Error getting upcoming event: $e');
    }
  }

  Future<void> searchEvents(String? search) async {
    state = state.copyWith(isLoading: true);
    if (search == null) {
      state = state.copyWith(
        filteredEventsResponse: state.eventsResponse,
        isLoading: false,
      );
      return;
    }
    try {
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
    } catch (e) {
      logger.e('Error searching events: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getUpcomingEvents() async {
    try {
      final eventsResponse = await _getEvents(EventSearchType.upcoming);
      state = state.copyWith(
        upcomingEventsResponse: eventsResponse,
      );
    } catch (e) {
      logger.e('Error getting upcoming events: $e');
    }
  }

  Future<void> getPastEvents() async {
    try {
      final eventsResponse = await _getEvents(EventSearchType.past);
      state = state.copyWith(
        pastEventsResponse: eventsResponse,
      );
    } catch (e) {
      logger.e('Error getting past events: $e');
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
      final updatedResponse = EventsResponse(
        events: updatedEvents,
        hasMore: newEvents.hasMore,
      );

      state = state.copyWith(
        upcomingEventsResponse: eventType == EventSearchType.upcoming
            ? updatedResponse
            : state.upcomingEventsResponse,
        pastEventsResponse: eventType == EventSearchType.past
            ? updatedResponse
            : state.pastEventsResponse,
      );
    } catch (e) {
      logger.e('Error loading more events: $e');
    }
  }

  Future<EventsResponse> _getEvents(
    EventSearchType eventType, {
    int offset = 0,
  }) async {
    final eventResponse = await _eventsRepository.getEvents(
      eventsFilter: EventsFilter(
        limit: _pageSize,
        offset: offset,
        eventSearchType: eventType,
      ),
    );

    final eventsWithPhotos = await Future.wait(
      eventResponse.events.map((event) async {
        if (event.userIdsWithPhoto == null ||
            event.eventStatus == EventStatus.draft) {
          return event;
        }
        return event.copyWith(
          participantPhotos: await _setPhotosFromLocalStorage(
            event.userIdsWithPhoto!.toList(),
          ),
        );
      }),
    );

    return EventsResponse(
      events: eventsWithPhotos,
      hasMore: eventResponse.hasMore,
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

  Future<List<Uint8List?>> _setPhotosFromLocalStorage(
    List<String> userIds,
  ) async {
    return Future.wait(
      userIds.map(
        (userId) async =>
            (await ref.read(databaseProvider).getTeamMemberPhoto(userId))
                ?.profilePicture,
      ),
    );
  }
}
