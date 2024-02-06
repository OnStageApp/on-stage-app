import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/data/event_repository.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventsNotifier extends _$EventsNotifier {
  final TimeUtils timeUtils = TimeUtils();

  @override
  EventsState build() => const EventsState();

  Future<void> init() async {
    if (state.events.isNotEmpty) {
      return;
    }
    await _init();
  }

  Future<void> _init() async {
    logger.i('init event provider state');
    try {
      await Future.wait([
        getPastEvents(),
        getThisWeekEvents(),
        getUpcomingEvents(),
      ]);
    } catch (error) {
      logger.e('Error loading events: $error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> searchEvents(String? search) async {
    state = state.copyWith(isLoading: true);
    final events = await ref
        .read(eventRepositoryProvider.notifier)
        .getEvents(search: search);

    state = state.copyWith(filteredEvents: events, isLoading: false);
  }

  Future<void> getPastEvents() async {
    state = state.copyWith(isLoading: true);
    final yesterday = timeUtils.getYesterdayDateTime();

    final pastEvents = await ref
        .read(eventRepositoryProvider.notifier)
        .getEvents(endDate: yesterday);

    state = state.copyWith(pastEvents: pastEvents, isLoading: false);
  }

  Future<void> getThisWeekEvents() async {
    state = state.copyWith(isLoading: true);

    final thisWeekEvents =
        await ref.read(eventRepositoryProvider.notifier).getEvents(
              startDate: timeUtils.getNowDateTime(),
              endDate: timeUtils.getEndOfTheWeekDateTime(),
            );

    state = state.copyWith(thisWeekEvents: thisWeekEvents, isLoading: false);
  }

  Future<void> getUpcomingEvents() async {
    state = state.copyWith(isLoading: true);

    final upcomingEvents =
        await ref.read(eventRepositoryProvider.notifier).getEvents(
              startDate: timeUtils.getStartOfTheNextWeekDateTime(),
            );

    state = state.copyWith(upcomingEvents: upcomingEvents, isLoading: false);
  }
}
