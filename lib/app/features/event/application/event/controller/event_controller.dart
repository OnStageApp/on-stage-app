import 'package:on_stage_app/app/features/event/application/event/controller/event_controller_state.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
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
    final dateTime = DateTime.parse(dateTimeString);
    state = state.copyWith(dateTime: dateTime);
  }

  void selectTeamMember(TeamMember member) {
    state = state.copyWith(
      selectedTeamMembers: [...state.selectedTeamMembers, member],
    );
  }

  void unSelectTeamMember(TeamMember member) {
    state = state.copyWith(
      selectedTeamMembers:
          state.selectedTeamMembers.where((p) => p.id != member.id).toList(),
    );
  }

  void addMembers() {
    final members = state.selectedTeamMembers;
    state = state.copyWith(
      addedMembers: [...state.addedMembers, ...members],
    );
  }

  void resetSelectedMembers() {
    state = state.copyWith(selectedTeamMembers: []);
  }

  void addRehearsal(RehearsalModel rehearsal) {
    state = state.copyWith(rehearsals: [...state.rehearsals, rehearsal]);
  }

  void removeRehearsal(RehearsalModel rehearsal) {
    state = state.copyWith(
      rehearsals: state.rehearsals.where((r) => r.id != rehearsal.id).toList(),
    );
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
