import 'dart:async';

import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_state.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/event_items/domain/update_event_item_index.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/application/event_item_templates_state.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/data/event_item_templates_repo.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/data/event_item_templates_repo_provider.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_templates_notifier.g.dart';

@Riverpod()
class EventItemTemplatesNotifier extends _$EventItemTemplatesNotifier {
  EventItemTemplatesRepo get _eventItemTemplatesRepo =>
      ref.read(eventItemTemplatesRepoProvider);

  @override
  EventItemTemplatesState build() {
    logger.i('Event Items Notifier rebuild');
    return const EventItemTemplatesState();
  }

  List<String> getSongIds() {
    return state.eventItemTemplates
        .where((item) => item.eventType == EventItemType.song)
        .map((item) => item.song!.id)
        .toList();
  }

  Future<void> getEventItems(String eventId) async {
    state = state.copyWith(isLoading: true);

    final eventItemTemplates = await _eventItemTemplatesRepo.getEventItems(eventId);

    final eventItemTemplatesWithPhotos = await Future.wait(
      eventItemTemplates.map((eventItem) async {
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
      eventItemTemplates: eventItemTemplatesWithPhotos,
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> updateMomentItem(EventItem eventItem) async {
    try {
      final eventItemCreate = EventItemCreate.fromEventItem(eventItem);
      final updatedEventItem = await _eventItemTemplatesRepo.updateEventItem(
        eventItem.id,
        eventItemCreate,
      );

      final updatedItems = state.eventItemTemplates.map((item) {
        return item.id == eventItem.id ? updatedEventItem : item;
      }).toList();

      state = state.copyWith(
        eventItemTemplates: updatedItems,
      );
    } catch (e, stackTrace) {
      logger.e('Error updating event item: $e\n$stackTrace');
      state = state.copyWith(
        eventItemTemplates: state.eventItemTemplates,
      );
    }
  }

  Future<void> updateSongIneventItemTemplates(SongModelV2 song) async {
    logger.i('Updating song in event items: ${song.title}');
    final updatedItems = state.eventItemTemplates.map((item) {
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
        state.copyWith(eventItemTemplates: updatedItems, songsFromEvent: updatedSongs);
  }

  // Future<void> fetchSongForEachEventItem() async {
  //   final songIds = state.eventItemTemplates
  //       .where((item) => item.eventType == EventItemType.song)
  //       .map((item) => item.song!.id)
  //       .toList();

  //   final songs = await Future.wait(
  //     songIds.map((id) async {
  //       final song = await songRepository.getSong(songId: id);
  //       return song;
  //     }).toList(),
  //   );
  //   state = state.copyWith(songsFromEvent: songs);
  // }

  Future<void> addEventItemMoment(EventItemCreate eventItem) async {
    state = state.copyWith(isLoading: true);

    final createEventItemRequest = eventItem.copyWith(
      index: state.eventItemTemplates.length,
    );

    final updatedEventItem =
        await _eventItemTemplatesRepo.addMomentItem(createEventItemRequest);

    state = state.copyWith(
      isLoading: false,
      eventItemTemplates: [...state.eventItemTemplates, updatedEventItem],
    );
  }

  Future<void> updateeventItemTemplatesIndexes(List<EventItem> eventItemTemplates) async {
    final originalItems = [...state.eventItemTemplates];
    state = state.copyWith(eventItemTemplates: eventItemTemplates);

    try {
      final updatedeventItemTemplates = eventItemTemplates
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

      await _eventItemTemplatesRepo.updateEventItemIndexes(updatedeventItemTemplates);
    } catch (e) {
      state = state.copyWith(eventItemTemplates: originalItems);
      rethrow;
    }
  }

  Future<void> deleteEventItem(String eventItemId) async {
    final deletedItemIndex =
        state.eventItemTemplates.indexWhere((item) => item.id == eventItemId);
    if (deletedItemIndex == -1) return;

    final originalItems = [...state.eventItemTemplates];
    final updatedItems = _getUpdatedItemsAfterDeletion(deletedItemIndex);

    state = state.copyWith(eventItemTemplates: updatedItems);

    try {
      await _eventItemTemplatesRepo.deleteEventItem(eventItemId);

      final updateRequests = updatedItems
          .where((item) => item.index != null)
          .map(
            (item) => UpdateEventItemIndex(
              eventItemId: item.id,
              index: item.index!,
            ),
          )
          .toList();

      if (updateRequests.isNotEmpty) {
        await _eventItemTemplatesRepo.updateEventItemIndexes(updateRequests);
      }
    } catch (e) {
      state = state.copyWith(eventItemTemplates: originalItems);
      rethrow;
    }
  }

  List<EventItem> _getUpdatedItemsAfterDeletion(int deletedIndex) {
    return state.eventItemTemplates
        .where((item) => item.id != state.eventItemTemplates[deletedIndex].id)
        .map((item) {
      if (item.index != null && item.index! > deletedIndex) {
        return item.copyWith(index: item.index! - 1);
      }
      return item;
    }).toList();
  }

  // Future<void> addSongItems(
  //   List<SongOverview> songs,
  //   String eventId,
  // ) async {
  //   final startIndex = state.eventItemTemplates.length;
  //   final createSongItemsRequest = songs
  //       .map(
  //         (song) => CreateSongItemRequest(
  //           songId: song.id,
  //           songTitle: song.title ?? '',
  //           index: startIndex + songs.indexOf(song),
  //         ),
  //       )
  //       .toList();

  //   final createAllSongItemsRequest = CreateAllSongItemsRequest(
  //     eventId: eventId,
  //     songItems: createSongItemsRequest,
  //   );

  //   final addedSongItems =
  //       await songRepository.addSongsToeventItemTemplates(createAllSongItemsRequest);

  //   state = state.copyWith(
  //     eventItemTemplates: [
  //       ...state.eventItemTemplates,
  //       ...addedSongItems,
  //     ],
  //   );
  // }

  void changeOrderCache(int oldIndex, int newIndex) {
    final items = state.eventItemTemplates.toList();
    final item = items.removeAt(oldIndex);

    final adjustedNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    items.insert(adjustedNewIndex, item);
    final reorderAllEvents = _reorderAllEvents(items);
    state = state.copyWith(eventItemTemplates: reorderAllEvents);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> removeLeadVocal(
    String eventItemId,
    String stagerId,
  ) async {
    final stagers = state.eventItemTemplates
            .firstWhere((item) => item.id == eventItemId)
            .assignedTo ??
        [];
    final updatedLeadVocals = List<StagerOverview>.from(stagers)
      ..removeWhere((s) => s.id == stagerId);
    state = state.copyWith(
      eventItemTemplates: state.eventItemTemplates.map((item) {
        if (item.id == eventItemId) {
          return item.copyWith(assignedTo: updatedLeadVocals);
        }
        return item;
      }).toList(),
    );
    unawaited(_eventItemTemplatesRepo.deleteLeadVocals(eventItemId, stagerId));
  }

  List<EventItem> _reorderAllEvents(List<EventItem> items) {
    final reorderAllEvents = items.map((e) {
      return e.copyWith(index: items.indexOf(e));
    }).toList();
    return reorderAllEvents;
  }
}
