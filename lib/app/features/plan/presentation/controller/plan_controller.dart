import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plan_controller.g.dart';

@Riverpod(keepAlive: true)
class PlanController extends _$PlanController {
  @override
  PlanControllerState build() {
    return const PlanControllerState();
  }

  void toggleYearlyPlan() {
    state = state.copyWith(isYearlyPlan: !state.isYearlyPlan);
  }
}
