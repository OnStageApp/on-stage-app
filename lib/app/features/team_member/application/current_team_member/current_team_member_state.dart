import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';

part 'current_team_member_state.freezed.dart';

@freezed
class CurrentTeamMemberState with _$CurrentTeamMemberState {
  const factory CurrentTeamMemberState({
    TeamMember? teamMember,
    @Default(false) bool isLoading,
  }) = _CurrentTeamMemberState;
}
