import 'dart:async';

import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_items_request.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_state.dart';
import 'package:on_stage_app/app/features/event_items/data/event_items_repository.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_items_notifier.g.dart';

@Riverpod(keepAlive: false)
class EventItemsNotifier extends _$EventItemsNotifier {
  EventItemsRepository? _eventItemsRepository;

  EventItemsRepository get eventItemsRepository {
    _eventItemsRepository ??= EventItemsRepository(ref.watch(dioProvider));
    return _eventItemsRepository!;
  }

  @override
  EventItemsState build() {
    final dio = ref.watch(dioProvider);
    _eventItemsRepository = EventItemsRepository(dio);
    print('Event Items Notifier rebuild');
    return const EventItemsState();
  }

  List<String> getSongIds() {
    return state.eventItems
        .where((item) => item.eventType == EventItemType.song)
        .map((item) => item.song!.id)
        .toList();
  }

  Future<void> getEventItems(String eventId) async {
    final eventItemsFuture = eventItemsRepository.getEventItems(eventId);

    final results = await Future.wait([
      eventItemsFuture,
      eventItemsFuture.then(_getSongEventItems),
    ]);

    state = state.copyWith(
      eventItems: results[0],
      songEventItems: results[1],
    );
  }

  Future<void> addEventItems(List<EventItem> eventItems, String eventId) async {
    state = state.copyWith(isLoading: true);

    final mappedEventItemsToRequest = eventItems
        .map(
          (eventItem) => EventItemCreate(
            index: eventItem.index,
            name: eventItem.name,
            songId: eventItem.song?.id,
          ),
        )
        .toList();

    final eventItemsRequest = EventItemsRequest(
      eventItems: mappedEventItemsToRequest,
      eventId: eventId,
    );
    final updatedEventItems =
        await eventItemsRepository.addEventItems(eventItemsRequest);
    state = state.copyWith(
      isLoading: false,
      eventItems: updatedEventItems,
      songEventItems: _getSongEventItems(updatedEventItems),
    );
  }

  void addEventItemCache(EventItem eventItem) {
    state = state.copyWith(
      eventItems: [...state.eventItems, eventItem],
    );
  }

  void removeEventItemCache(EventItem eventItem) {
    state = state.copyWith(
      eventItems: state.eventItems
          .where((item) => item.index != eventItem.index)
          .toList(),
    );
  }

  List<EventItem> _getSongEventItems(List<EventItem> eventItems) {
    return eventItems
        .where((item) => item.eventType == EventItemType.song)
        .toList();
  }

  void addSelectedSongsToEventItemsCache(List<SongOverview> songs) {
    final startIndex = state.eventItems.length;

    final newSongItems = songs.map((song) {
      return EventItem.fromSong(song, startIndex + songs.indexOf(song));
    }).toList();

    state = state.copyWith(
      eventItems: [
        ...state.eventItems,
        ...newSongItems,
      ],
    );
  }

  void addSelectedMomentsToEventItemsCache(List<String> moments) {
    final startIndex = state.eventItems.length;

    final newMomentItems = moments.map((moment) {
      return EventItem.fromMoment(
        moment,
        startIndex + moments.indexOf(moment),
      );
    }).toList();

    state = state.copyWith(
      eventItems: [...state.eventItems, ...newMomentItems],
    );
  }

  void changeOrderCache(int oldIndex, int newIndex) {
    final items = state.eventItems.toList();
    final item = items.removeAt(oldIndex);

    final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    items.insert(adjustedNewIndex, item);
    final reorderAllEvents = _reorderAllEvents(items);
    state = state.copyWith(eventItems: reorderAllEvents);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  List<EventItem> _reorderAllEvents(List<EventItem> items) {
    final reorderAllEvents = items.map((e) {
      return EventItem(
        index: items.indexOf(e),
        name: e.name,
        eventId: e.eventId,
        song: e.song,
      );
    }).toList();
    return reorderAllEvents;
  }
}
