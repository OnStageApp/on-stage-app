import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/user/domain/models/profile/profile_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed()
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required Profile profile,
    required String username,
    required String password,
    required String email,
  }) = _User;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
