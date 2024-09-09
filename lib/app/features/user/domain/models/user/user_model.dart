import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'image', fromJson: _imageFromJson, toJson: _imageToJson)
    Uint8List? image,
  }) = _User;

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
