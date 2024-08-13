import 'package:on_stage_app/app/features/event/application/event/controller/event_controller_state.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_type_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart';

@Riverpod(keepAlive: true)
class EventController extends _$EventController {
  @override
  EventControllerState build() {
    return const EventControllerState();
  }

  Future<void> init() async {
    logger.i('init event controller state');
  }

  void setEventName(String name) {
    state = state.copyWith(eventName: name);
  }

  void setEventLocation(String location) {
    state = state.copyWith(eventLocation: location);
  }

  void setDateTime(String date, String time) {
    try {
      final dateParts = date.split('/');
      final timeParts = time.split(':');

      if (dateParts.length != 3 || timeParts.length != 2) {
        throw const FormatException('Invalid date or time format');
      }

      final year = int.parse(dateParts[2]);
      final month = int.parse(dateParts[0]);
      final day = int.parse(dateParts[1]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final combinedDateTime = DateTime(year, month, day, hour, minute);

      state = state.copyWith(
        dateTime: combinedDateTime,
      );
    } catch (e) {
      logger.e('Error parsing date or time: $e');
    }
  }

  void addParticipant(StagerOverview participant) {
    state = state.copyWith(
      addedParticipants: [...state.addedParticipants, participant],
    );
    if (state.addedParticipants.isNotEmpty) {
      state = state.copyWith(
          invitePeopleButtonText:
              'Invite ${state.addedParticipants.length} people');
    }
  }

  void removeParticipant(StagerOverview participant) {
    state = state.copyWith(
      addedParticipants:
          state.addedParticipants.where((p) => p.id != participant.id).toList(),
    );
    if (state.addedParticipants.isEmpty) {
      state = state.copyWith(invitePeopleButtonText: 'Invite People');
    }
  }

  void addRehearsal(Rehearsal rehearsal) {
    state = state.copyWith(rehearsals: [...state.rehearsals, rehearsal]);
  }

  void removeRehearsal(Rehearsal rehearsal) {
    state = state.copyWith(
      rehearsals: state.rehearsals.where((r) => r.id != rehearsal.id).toList(),
    );
  }

  void addSong(SongOverview addedSong) {
    state = state.copyWith(songs: [...state.songs, addedSong]);
  }

  void addEventItem(EventItem eventItem) {
    state = state.copyWith(eventItems: [...state.eventItems, eventItem]);
  }

  void removeEventItem(EventItem eventItem) {
    state = state.copyWith(
      eventItems: state.eventItems
          .where((item) => item.index != eventItem.index)
          .toList(),
    );
  }

  void removeSong(SongOverview removedSong) {
    state = state.copyWith(
      songs: state.songs.where((song) => song.id != removedSong.id).toList(),
    );
  }

  void addMoment(String moment) {
    state = state.copyWith(moments: [...state.moments, moment]);
  }

  void removeMoment(String moment) {
    state = state.copyWith(
      moments: state.moments.where((m) => m != moment).toList(),
    );
  }

  void addSelectedSongsToEventItems() {
    // Calculate the start index for new song items
    final startIndex = state.eventItems.length;

    // Add new song items that are selected
    final newSongItems = state.songs.map((song) {
      return EventItem(
        songId: song.id,
        index: startIndex + state.songs.indexOf(song),
        name: song.title,
        eventType: EventTypeEnum.song,
      );
    }).toList();

    // Update the state with the updated event items and clear the songs list
    state = state.copyWith(eventItems: [
      ...state.eventItems,
      ...newSongItems,
    ], songs: [] // Clear the songs list
        );
  }

  void addSelectedMomentsToEventItems() {
    // Calculate the start index for new moment items
    final startIndex = state.eventItems.length;

    // Add new moment items that are selected
    final newMomentItems = state.moments.map((moment) {
      return EventItem(
        index: startIndex + state.moments.indexOf(moment),
        name: moment,
        eventType: EventTypeEnum.moment,
      );
    }).toList();

    // Update the state with the updated event items and clear the moments list
    state = state.copyWith(
        eventItems: [...state.eventItems, ...newMomentItems],
        moments: [] // Clear the moments list
        );
  }

  void reorderEventItems(int oldIndex, int newIndex) {
    final items = state.eventItems.toList();
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(eventItems: items);
  }
}
