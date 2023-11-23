import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_repository.g.dart';

@riverpod
class EventRepository extends _$EventRepository {
  @override
  FutureOr build() {}

  Future<List<EventModel>> fetchEvents() async {
    final events = await Future.delayed(
      const Duration(seconds: 1),
      () => SongDummy.eventsDummy,
    );
    return events;
  }

  Future<List<EventModel>> getPastEvents() async {
    final allEvents = await fetchEvents();
    final currentDate = DateTime.now();

    final pastEvents = allEvents.where((event) {
      final eventDate = DateTime.parse(event.date);
      return eventDate.isBefore(currentDate);
    }).toList();

    return pastEvents;
  }

  Future<List<EventModel>> getThisWeekEvents() async {
    final allEvents = await fetchEvents();
    final currentDate = DateTime.now();
    final nextWeekDate = currentDate.add(const Duration(days: 7));

    final thisWeekEvents = allEvents.where((event) {
      final eventDate = DateTime.parse(event.date);
      return eventDate.isAfter(currentDate) && eventDate.isBefore(nextWeekDate);
    }).toList();

    return thisWeekEvents;
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    final allEvents = await fetchEvents();
    final nextWeekDate = DateTime.now().add(const Duration(days: 7));

    final upcomingEvents = allEvents.where((event) {
      final eventDate = DateTime.parse(event.date);
      return eventDate.isAfter(nextWeekDate);
    }).toList();

    return upcomingEvents;
  }
}
