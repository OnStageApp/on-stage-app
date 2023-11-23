import 'package:on_stage_app/app/features/event/application/event_state.dart';
import 'package:on_stage_app/app/features/event/data/event_repository.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {

  @override
  EventState build() {
    return const EventState();
  }

  Future<void> init() async {
    if (state.events.isNotEmpty) {
      return;
    }
    logger.i('init event provider state');
    await getPastEvents();
    await getThisWeekEvents();
    await getUpcomingEvents();
  }

  Future<void> getPastEvents() async {
    ref.read(loadingProvider.notifier).state = true;
    final pastEvents = await ref.read(eventRepositoryProvider.notifier).getPastEvents();

    final pastSevenDaysEvents = pastEvents.where((event) {
      final eventDate = DateTime.parse(event.date);
      final now = DateTime.now();
      return eventDate.isBefore(now.subtract(const Duration(days: 7)));
    }).toList();

    ref.read(loadingProvider.notifier).state = false;
    state = state.copyWith(pastEvents: pastEvents);
  }

  Future<void> getThisWeekEvents() async {
    ref.read(loadingProvider.notifier).state = true;
    final thisWeekEvents = await ref.read(eventRepositoryProvider.notifier).getThisWeekEvents();

    thisWeekEvents.sort((a, b) {
      final aDate = DateTime.parse(a.date);
      final bDate = DateTime.parse(b.date);
      return aDate.compareTo(bDate);
    });

    ref.read(loadingProvider.notifier).state = false;
    state = state.copyWith(thisWeekEvents: thisWeekEvents);
  }

  Future<void> getUpcomingEvents() async {
    ref.read(loadingProvider.notifier).state = true;
    final upcomingEvents = await ref.read(eventRepositoryProvider.notifier).getUpcomingEvents();

    upcomingEvents.sort((a, b) {
      final aDate = DateTime.parse(a.date);
      final bDate = DateTime.parse(b.date);
      return aDate.compareTo(bDate);
    });

    ref.read(loadingProvider.notifier).state = false;
    state = state.copyWith(upcomingEvents: upcomingEvents);
  }
}
