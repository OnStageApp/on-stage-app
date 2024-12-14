import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';

part 'create_team_member_request.freezed.dart';
part 'create_team_member_request.g.dart';

@Freezed()
class CreateTeamMemberRequest with _$CreateTeamMemberRequest {
  const factory CreateTeamMemberRequest({
    required TeamMemberRole? newMemberRole,
    String? email,
    String? teamMemberInvited,
  }) = _CreateTeamMemberRequest;

  factory CreateTeamMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTeamMemberRequestFromJson(json);
}
