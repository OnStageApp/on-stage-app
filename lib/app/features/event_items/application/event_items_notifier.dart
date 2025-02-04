import 'dart:async';

import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_state.dart';
import 'package:on_stage_app/app/features/event_items/data/event_items_repository.dart';
import 'package:on_stage_app/app/features/event_items/domain/create_all_song_items_request.dart';
import 'package:on_stage_app/app/features/event_items/domain/create_song_item_request.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/event_items/domain/update_event_item_index.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_items_notifier.g.dart';

@Riverpod()
class EventItemsNotifier extends _$EventItemsNotifier {
  EventItemsRepository? _eventItemsRepository;
  SongRepository? _songRepository;

  EventItemsRepository get eventItemsRepository {
    _eventItemsRepository ??= EventItemsRepository(ref.watch(dioProvider));
    return _eventItemsRepository!;
  }

  SongRepository get songRepository {
    _songRepository ??= SongRepository(ref.watch(dioProvider));
    return _songRepository!;
  }

  @override
  EventItemsState build() {
    final dio = ref.watch(dioProvider);
    _eventItemsRepository = EventItemsRepository(dio);
    _songRepository = SongRepository(dio);
    logger.i('Event Items Notifier rebuild');
    return const EventItemsState();
  }

  List<String> getSongIds() {
    return state.eventItems
        .where((item) => item.eventType == EventItemType.song)
        .map((item) => item.song!.id)
        .toList();
  }

  Future<void> getEventItems(String eventId) async {
    state = state.copyWith(isLoading: true);

    final eventItems = await eventItemsRepository.getEventItems(eventId);

    final eventItemsWithPhotos = await Future.wait(
      eventItems.map((eventItem) async {
        if (eventItem.assignedTo == null || eventItem.assignedTo!.isEmpty) {
          return eventItem;
        }

        final updatedStagers = await Future.wait(
          eventItem.assignedTo!.map((stager) async {
            final photo = await ref
                .read(databaseProvider)
                .getTeamMemberPhoto(stager.userId);
            return stager.copyWith(profilePicture: photo?.profilePicture);
          }),
        );

        return eventItem.copyWith(assignedTo: updatedStagers);
      }),
    );

    state = state.copyWith(
      eventItems: eventItemsWithPhotos,
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> updateMomentItem(EventItem eventItem) async {
    try {
      final eventItemCreate = EventItemCreate.fromEventItem(eventItem);
      final updatedEventItem = await eventItemsRepository.updateEventItem(
        eventItem.id,
        eventItemCreate,
      );

      final updatedEventItemWithPhotos =
          await _fetchStagersPhotos(updatedEventItem);

      final updatedItems = state.eventItems.map((item) {
        return item.id == eventItem.id ? updatedEventItemWithPhotos : item;
      }).toList();

      state = state.copyWith(
        eventItems: updatedItems,
      );
    } catch (e, stackTrace) {
      logger.e('Error updating event item: $e\n$stackTrace');
      state = state.copyWith(
        eventItems: state.eventItems,
      );
    }
  }

  Future<void> updateSongInEventItems(SongModelV2 song) async {
    logger.i('Updating song in event items: ${song.title}');
    final updatedItems = state.eventItems.map((item) {
      if (item.eventType == EventItemType.song && item.song!.id == song.id) {
        return item.copyWith(song: SongOverview.fromSong(song));
      }
      return item;
    }).toList();

    final updatedSongs = state.songsFromEvent.map((s) {
      if (s.id == song.id) {
        return song;
      }
      return s;
    }).toList();

    state =
        state.copyWith(eventItems: updatedItems, songsFromEvent: updatedSongs);
  }

  Future<void> fetchSongForEachEventItem() async {
    final songIds = state.eventItems
        .where((item) => item.eventType == EventItemType.song)
        .map((item) => item.song!.id)
        .toList();

    final songs = await Future.wait(
      songIds.map((id) async {
        final song = await songRepository.getSong(songId: id);
        return song;
      }).toList(),
    );
    state = state.copyWith(songsFromEvent: songs);
  }

  Future<void> addEventItemMoment(EventItemCreate eventItem) async {
    state = state.copyWith(isLoading: true);

    final createEventItemRequest = eventItem.copyWith(
      index: state.eventItems.length,
    );

    final updatedEventItem =
        await eventItemsRepository.addMomentItem(createEventItemRequest);
    final eventItemWithPhotos = await _fetchStagersPhotos(updatedEventItem);

    state = state.copyWith(
      isLoading: false,
      eventItems: [...state.eventItems, eventItemWithPhotos],
    );
  }

  Future<void> updateEventItemsIndexes(List<EventItem> eventItems) async {
    final originalItems = [...state.eventItems];
    state = state.copyWith(eventItems: eventItems);

    try {
      final updatedEventItems = eventItems
          .map((e) {
            if (e.index != null) {
              return UpdateEventItemIndex(
                eventItemId: e.id,
                index: e.index!,
              );
            }
            return null;
          })
          .whereType<UpdateEventItemIndex>()
          .toList();

      await eventItemsRepository.updateEventItemIndexes(updatedEventItems);
    } catch (e) {
      state = state.copyWith(eventItems: originalItems);
      rethrow;
    }
  }

  Future<void> deleteEventItem(String eventItemId) async {
    final deletedItemIndex =
        state.eventItems.indexWhere((item) => item.id == eventItemId);
    if (deletedItemIndex == -1) return;

    final originalItems = [...state.eventItems];
    final updatedItems = _getUpdatedItemsAfterDeletion(deletedItemIndex);

    state = state.copyWith(eventItems: updatedItems);

    try {
      await eventItemsRepository.deleteEventItem(eventItemId);

      final updateRequests = updatedItems
          .where((item) => item.index != null)
          .map((item) => UpdateEventItemIndex(
                eventItemId: item.id,
                index: item.index!,
              ))
          .toList();

      if (updateRequests.isNotEmpty) {
        await eventItemsRepository.updateEventItemIndexes(updateRequests);
      }
    } catch (e) {
      state = state.copyWith(eventItems: originalItems);
      rethrow;
    }
  }

  List<EventItem> _getUpdatedItemsAfterDeletion(int deletedIndex) {
    return state.eventItems
        .where((item) => item.id != state.eventItems[deletedIndex].id)
        .map((item) {
      if (item.index != null && item.index! > deletedIndex) {
        return item.copyWith(index: item.index! - 1);
      }
      return item;
    }).toList();
  }

  Future<void> addSongItems(
    List<SongOverview> songs,
    String eventId,
  ) async {
    final startIndex = state.eventItems.length;
    final createSongItemsRequest = songs
        .map(
          (song) => CreateSongItemRequest(
            songId: song.id,
            songTitle: song.title ?? '',
            index: startIndex + songs.indexOf(song),
          ),
        )
        .toList();

    final createAllSongItemsRequest = CreateAllSongItemsRequest(
      eventId: eventId,
      songItems: createSongItemsRequest,
    );

    final addedSongItems =
        await songRepository.addSongsToEventItems(createAllSongItemsRequest);

    state = state.copyWith(
      eventItems: [
        ...state.eventItems,
        ...addedSongItems,
      ],
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

  Future<void> removeLeadVocal(
    String eventItemId,
    String stagerId,
  ) async {
    final stagers = state.eventItems
            .firstWhere((item) => item.id == eventItemId)
            .assignedTo ??
        [];
    final updatedLeadVocals = List<StagerOverview>.from(stagers)
      ..removeWhere((s) => s.id == stagerId);
    state = state.copyWith(
      eventItems: state.eventItems.map((item) {
        if (item.id == eventItemId) {
          return item.copyWith(assignedTo: updatedLeadVocals);
        }
        return item;
      }).toList(),
    );
    unawaited(eventItemsRepository.deleteLeadVocals(eventItemId, stagerId));
  }

  Future<void> updateLeadVocals(
    String eventItemId,
    List<StagerOverview> leadVocalStagers,
  ) async {
    state = state.copyWith(
      eventItems: state.eventItems.map((item) {
        if (item.id == eventItemId) {
          return item.copyWith(assignedTo: leadVocalStagers);
        }
        return item;
      }).toList(),
    );
    final stagerIds = leadVocalStagers.map((e) => e.id).toList();
    unawaited(eventItemsRepository.updateLeadVocals(eventItemId, stagerIds));
  }

  List<EventItem> _reorderAllEvents(List<EventItem> items) {
    final reorderAllEvents = items.map((e) {
      return e.copyWith(index: items.indexOf(e));
    }).toList();
    return reorderAllEvents;
  }

  Future<EventItem> _fetchStagersPhotos(EventItem eventItem) async {
    if (eventItem.assignedTo == null || eventItem.assignedTo!.isEmpty) {
      return eventItem;
    }

    final updatedStagers = await Future.wait(
      eventItem.assignedTo!.map((stager) async {
        final photo =
            await ref.read(databaseProvider).getTeamMemberPhoto(stager.userId);
        return stager.copyWith(profilePicture: photo?.profilePicture);
      }),
    );

    return eventItem.copyWith(assignedTo: updatedStagers);
  }
}
