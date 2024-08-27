import 'package:on_stage_app/app/features/event/application/events/events_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventsNotifier extends _$EventsNotifier {
  final TimeUtils timeUtils = TimeUtils();
  late final EventsRepository _eventsRepository;

  @override
  EventsState build() {
    final dio = ref.read(dioProvider);
    _eventsRepository = EventsRepository(dio);
    return const EventsState();
  }

  Future<void> searchEvents(String? search) async {
    state = state.copyWith(isLoading: true);
    if (search.isNullEmptyOrWhitespace) {
      state = state.copyWith(filteredEvents: state.events, isLoading: false);
      return;
    }
    final events = await _eventsRepository.getEvents(search: search);

    state = state.copyWith(filteredEvents: events, isLoading: false);
  }

  Future<void> getEvents() async {
    final events = await _eventsRepository.getEvents();
    state = state.copyWith(events: events, filteredEvents: events);
  }
}
