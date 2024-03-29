import 'package:on_stage_app/app/features/event/application/event/event_state.dart';
import 'package:on_stage_app/app/features/event/data/event_repository.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
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
    if (state.event != null) {
      return;
    }
    logger.i('init event provider state');
  }

  Future<void> getEventById(String eventId) async {
    state = state.copyWith(isLoading: true);
    final event =
        await ref.read(eventRepositoryProvider.notifier).getEventById(eventId);

    state = state.copyWith(event: event, isLoading: false);
    await getPlaylist();
  }

  Future<void> getPlaylist() async {
    if (state.playlist.isNotEmpty) {
      state = state.copyWith(playlist: state.playlist);
      return;
    }
    state = state.copyWith(isLoading: true);
    final playlist = [];
    // await ref.read(eventRepositoryProvider.notifier).fetchPlaylist();
    state = state.copyWith(playlist: [], isLoading: false);
  }

  Future<void> getStagers() async {
    if (state.stagers.isNotEmpty) {
      return;
    }
    state = state.copyWith(isLoading: true);
    final stagers =
        await ref.read(eventRepositoryProvider.notifier).getStagers();
    state = state.copyWith(stagers: stagers, isLoading: false);
  }

  Future<void> addEvent(EventModel event) async {
    state = state.copyWith(isLoading: true);
    await ref.read(eventRepositoryProvider.notifier).createEvent(event);
    state = state.copyWith(isLoading: false);
  }
}
