import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';

part 'team_members_state.freezed.dart';

@freezed
class TeamMembersState with _$TeamMembersState {
  const factory TeamMembersState({
    @Default([]) List<TeamMember> teamMembers,
    @Default([]) List<TeamMember> uninvitedTeamMembers,
    @Default(false) bool isLoading,
    String? error,
  }) = _TeamMembersState;
}
