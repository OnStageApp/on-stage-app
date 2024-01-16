import 'package:on_stage_app/app/features/event/application/event_state.dart';
import 'package:on_stage_app/app/features/event/data/event_repository.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  final TimeUtils timeUtils = TimeUtils();

  @override
  EventState build() {
    return const EventState();
  }

  Future<void> init() async {
    if (state.events.isNotEmpty) {
      return;
    }
    logger.i('init event provider state');
    await getPlaylist();
    await getPastEvents();
    await getThisWeekEvents();
    await getUpcomingEvents();
  }

  Future<void> getEventById(String eventId) async{
   // ref.read(loadingProvider.notifier).state = true;
    final event = await ref
    .read(eventRepositoryProvider.notifier)
    .getEventById(eventId);

    state = state.copyWith(event: event);
    //ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> getPlaylist() async {
    if (state.playlist.isNotEmpty) {
      state = state.copyWith(playlist: state.playlist);
      return;
    }
    ref.read(loadingProvider.notifier).state = true;
    final playlist = await ref.read(eventRepositoryProvider.notifier).fetchPlaylist();
    state = state.copyWith(playlist: playlist);
    ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> searchEvents(String? search) async {
    ref.read(loadingProvider.notifier).state = true;
    final events = await ref
        .read(eventRepositoryProvider.notifier)
        .getEvents(search: search);

    state = state.copyWith(filteredEvents: events);
    ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> getPastEvents() async {
    ref.read(loadingProvider.notifier).state = true;
    final yesterday = timeUtils.getYesterdayDateTime();

    final pastEvents = await ref
        .read(eventRepositoryProvider.notifier)
        .getEvents(endDate: yesterday);

    state = state.copyWith(pastEvents: pastEvents);
    ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> getThisWeekEvents() async {
    ref.read(loadingProvider.notifier).state = true;

    final thisWeekEvents =
        await ref.read(eventRepositoryProvider.notifier).getEvents(
              startDate: timeUtils.getNowDateTime(),
              endDate: timeUtils.getEndOfTheWeekDateTime(),
            );

    state = state.copyWith(thisWeekEvents: thisWeekEvents);
    ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> getUpcomingEvents() async {
    ref.read(loadingProvider.notifier).state = true;

    final upcomingEvents =
        await ref.read(eventRepositoryProvider.notifier).getEvents(
              startDate: timeUtils.getStartOfTheNextWeekDateTime(),
            );

    state = state.copyWith(upcomingEvents: upcomingEvents);
    ref.read(loadingProvider.notifier).state = false;
  }

  Future<void> addEvent(EventModel event) async {
    ref.read(loadingProvider.notifier).state = true;
    await ref.read(eventRepositoryProvider.notifier).createEvent(event);
    ref.read(loadingProvider.notifier).state = false;
  }
}
