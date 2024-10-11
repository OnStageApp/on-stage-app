import 'package:on_stage_app/app/features/onboarding/presentation/controller/onboarding_fifth_state.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_fifth_controller.g.dart';

@Riverpod(keepAlive: true)
class OnboardingFifthController extends _$OnboardingFifthController {
  @override
  OnboardingFifthState build() {
    return const OnboardingFifthState();
  }

  void updateName({required String fullName}) {
    state = state.copyWith(fullName: fullName);
  }

  void updatePosition({required Position position}) {
    state = state.copyWith(position: position);
  }

  void updateEmail({required String email}) {
    state = state.copyWith(email: email);
  }
}
