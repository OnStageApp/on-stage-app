import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_member_photo.freezed.dart';

@Freezed()
class TeamMemberPhoto with _$TeamMemberPhoto {
  const factory TeamMemberPhoto({
    required String userId,
    Uint8List? profilePicture,
  }) = _TeamMemberPhoto;
}
