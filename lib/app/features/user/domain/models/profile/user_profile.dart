import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@Freezed()
class UserProfileInfo with _$UserProfileInfo {
  const factory UserProfileInfo({
    String? name,
    String? email,
    String? username,
    required Position? position,
    String? photoUrl,
    @JsonKey(name: 'image', fromJson: _imageFromJson, toJson: _imageToJson)
    Uint8List? image,
  }) = _UserProfileInfo;

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) =>
      _$UserProfileInfoFromJson(json);
}

Uint8List? _imageFromJson(String? json) {
  if (json == null) return null;
  return base64Decode(json);
}

String? _imageToJson(Uint8List? object) {
  if (object == null) return null;
  return base64Encode(object);
}
