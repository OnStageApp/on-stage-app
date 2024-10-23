import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';

part 'plan_state.freezed.dart';

@freezed
class PlanState with _$PlanState {
  const factory PlanState({
    @Default([]) List<Plan> plans,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
  }) = _PlanState;
}
