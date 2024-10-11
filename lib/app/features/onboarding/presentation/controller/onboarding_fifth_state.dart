import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';

part 'onboarding_fifth_state.freezed.dart';

@freezed
class OnboardingFifthState with _$OnboardingFifthState {
  const factory OnboardingFifthState({
    String? fullName,
    String? email,
    Position? position,
  }) = _OnboardingFifthState;
}
