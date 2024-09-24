import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_member_photo_response.freezed.dart';
part 'team_member_photo_response.g.dart';

@Freezed()
class TeamMemberPhotoResponse with _$TeamMemberPhotoResponse {
  const factory TeamMemberPhotoResponse({
    required String userId,
    String? photoUrl,
  }) = _TeamMemberPhotoResponse;

  factory TeamMemberPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberPhotoResponseFromJson(json);
}
