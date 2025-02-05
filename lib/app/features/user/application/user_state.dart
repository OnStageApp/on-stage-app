import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    List<UserModel>? users,
    @Default([]) List<UserModel> uninvitedUsers,
    UserModel? currentUser,
    @Default(false) bool isLoading,
    String? error,
  }) = _UserState;
}
