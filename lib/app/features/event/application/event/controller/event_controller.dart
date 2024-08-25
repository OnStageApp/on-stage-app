import 'package:on_stage_app/app/features/event/application/event/controller/event_controller_state.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_type_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart';

@Riverpod()
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

  void setDateTime(String dateTimeString) {
    final dateTime = TimeUtils().parseDateTime(dateTimeString);
    state = state.copyWith(dateTime: dateTime);
  }

  //TODO: a user has to be added as a stager, i have to update this method, maybe create a new user_controller class
  void addParticipant(User participant) {
    print('addParticipant ${participant.name}');
    state = state.copyWith(
      addedUsers: [...state.addedUsers, participant],
    );
    if (state.addedUsers.isNotEmpty) {
      state = state.copyWith(
          invitePeopleButtonText: 'Invite ${state.addedUsers.length} people');
    }
  }

  void removeParticipant(User participant) {
    state = state.copyWith(
      addedUsers:
          state.addedUsers.where((p) => p.id != participant.id).toList(),
    );
    if (state.addedUsers.isEmpty) {
      state = state.copyWith(invitePeopleButtonText: 'Invite People');
    }
  }

  void addRehearsal(RehearsalModel rehearsal) {
    state = state.copyWith(rehearsals: [...state.rehearsals, rehearsal]);
  }

  void removeRehearsal(RehearsalModel rehearsal) {
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

  String getAcceptedInviteesLabel() {
    final stagers = ref.read(eventNotifierProvider).stagers;
    final acceptedStagers = stagers
        .where(
          (stager) => stager.participationStatus == StagerStatusEnum.CONFIRMED,
        )
        .toList();
    if (acceptedStagers.isNotEmpty) {
      return '${acceptedStagers.length}/${stagers.length} confirmed';
    } else {
      return '';
    }
  }
}
