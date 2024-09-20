import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_notifier.dart';
import 'package:on_stage_app/app/features/amazon_s3/amazon_s3_repository.dart';
import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_search_type.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_filter.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_response.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/dio_s3_client/dio_s3_client.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@Riverpod()
class EventsNotifier extends _$EventsNotifier {
  final TimeUtils timeUtils = TimeUtils();
  late final EventsRepository _eventsRepository;
  late final AmazonS3Repository _s3Repository;
  static const int _pageSize = 15;

  @override
  EventsState build() {
    final dio = ref.read(dioProvider);
    final dioS3 = ref.read(dioS3Provider);
    _eventsRepository = EventsRepository(dio);
    _s3Repository = AmazonS3Repository(dioS3);
    return const EventsState();
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

  Future<void> getUpcomingEvent() async {
    try {
      final event = await _eventsRepository.getUpcomingEvent();
      if (event?.stagerPhotoUrls == null) {
        state = state.copyWith(upcomingEvent: event);
      } else {
        final photoFutures = event!.stagerPhotoUrls!.map(
          ref.read(amazonS3NotifierProvider.notifier).getPhotoFromAWS,
        );
        final photos = await Future.wait(photoFutures);

        final allPhotos = photos.where((photo) => photo != null).toList();

        final newEvent = event.copyWith(stagerPhotos: allPhotos);

        state = state.copyWith(upcomingEvent: newEvent);
      }
    } on DioException catch (e) {
      logger.e('Error getting upcoming event1 $e');
    } catch (e) {
      logger.e('Error getting upcoming event2 $e');
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
    try {
      final eventsResponse = await _getEvents(EventSearchType.upcoming);
      state = state.copyWith(
        upcomingEventsResponse: eventsResponse,
      );
    } catch (e) {}
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
      state = state.copyWith(
        upcomingEventsResponse: eventType == EventSearchType.upcoming
            ? EventsResponse(events: updatedEvents, hasMore: newEvents.hasMore)
            : state.upcomingEventsResponse,
        pastEventsResponse: eventType == EventSearchType.past
            ? EventsResponse(events: updatedEvents, hasMore: newEvents.hasMore)
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
    final eventResponseWithPhotos = _setPhotosFromS3(eventResponse);
    return eventResponseWithPhotos;
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

  Future<EventsResponse> _setPhotosFromS3(EventsResponse eventsResponse) async {
    final eventFutures = eventsResponse.events.map((event) async {
      if (event.stagerPhotoUrls == null ||
          event.eventStatus == EventStatus.draft) {
        return event;
      }
      final photoFutures = event.stagerPhotoUrls!.map(
        ref.read(amazonS3NotifierProvider.notifier).getPhotoFromAWS,
      );
      final photos = await Future.wait(photoFutures);

      final allPhotos = photos.where((photo) => photo != null).toList();

      return event.copyWith(participantPhotos: allPhotos);
    });

    final newEvents = await Future.wait(eventFutures);

    return eventsResponse.copyWith(events: newEvents);
  }
}
