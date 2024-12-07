import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';

part 'user_request.freezed.dart';
part 'user_request.g.dart';

@Freezed()
class UserRequest with _$UserRequest {
  const factory UserRequest({
    String? name,
    String? username,
    String? revenueCatId,
    Position? position,
  }) = _UserRequest;

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);
}
