import 'package:on_stage_app/app/features/onboarding/presentation/controller/onboarding_fifth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_fifth_controller.g.dart';

@Riverpod(keepAlive: true)
class OnboardingFifthController extends _$OnboardingFifthController {
  @override
  OnboardingFifthState build() {
    return const OnboardingFifthState();
  }

  void updateUsername({required String username}) {
    state = state.copyWith(username: username);
  }
}
