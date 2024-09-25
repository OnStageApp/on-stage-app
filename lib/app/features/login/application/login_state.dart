import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoggedIn,
    @Default(false) bool isLoading,
    @Default('') String error,
    User? user,
  }) = _LoginState;
}
