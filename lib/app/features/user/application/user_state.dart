import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/features/user/domain/models/user/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    List<User>? users,
    @Default([]) List<User> uninvitedUsers,
    UserModel? currentUser,
    Uint8List? userPhoto,
    @Default(false) bool isLoading,
  }) = _UserState;
}
