import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed()
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required Position? position,
    String? email,
    String? username,
    String? photoUrl,
    String? name,
    @JsonKey(name: 'image', fromJson: _imageFromJson, toJson: _imageToJson)
    Uint8List? image,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

Uint8List? _imageFromJson(String? json) {
  if (json == null) return null;
  return base64Decode(json);
}

String? _imageToJson(Uint8List? object) {
  if (object == null) return null;
  return base64Encode(object);
}
