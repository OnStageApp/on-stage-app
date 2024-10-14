import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_controller_state.freezed.dart';

@freezed
class PlanControllerState with _$PlanControllerState {
  const factory PlanControllerState({
    @Default(true) bool isYearlyPlan,
  }) = _PlanControllerState;
}
