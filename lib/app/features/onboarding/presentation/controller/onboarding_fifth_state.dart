import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_fifth_state.freezed.dart';

@freezed
class OnboardingFifthState with _$OnboardingFifthState {
  const factory OnboardingFifthState({
    String? username,
  }) = _OnboardingFifthState;
}
