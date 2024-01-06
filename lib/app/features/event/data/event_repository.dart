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
      () => SongDummy.thisWeekEventsDummy,
    );
    return events;
  }

  Future<List<EventModel>> getEventsByRange( DateTime? startDate,  DateTime? endDate ) async {
  final thisWeekEvents = await fetchEvents();

  return thisWeekEvents;
  }

  }



