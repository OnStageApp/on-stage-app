import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/invite_status/invite_status.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';

part 'team_member.freezed.dart';
part 'team_member.g.dart';

@Freezed()
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    required String? name,
    required String userId,
    required String? teamId,
    required TeamMemberRole? role,
    required InviteStatus? inviteStatus,
    required String? photoUrl,
    @JsonKey(includeFromJson: false) Uint8List? profilePicture,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
}
