import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_request.freezed.dart';
part 'user_request.g.dart';

@Freezed()
class UserRequest with _$UserRequest {
  const factory UserRequest({
    String? name,
    String? revenueCatId,
  }) = _UserRequest;

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);
}
