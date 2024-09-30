import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';

part 'edit_team_member_request.freezed.dart';
part 'edit_team_member_request.g.dart';

@Freezed()
class EditTeamMemberRequest with _$EditTeamMemberRequest {
  const factory EditTeamMemberRequest({
    TeamMemberRole? newMemberRole,
    Position? position,
  }) = _EditTeamMemberRequest;

  factory EditTeamMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$EditTeamMemberRequestFromJson(json);
}
