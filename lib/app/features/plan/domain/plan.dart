import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/plan/domain/plan_feature.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

@Freezed()
class Plan with _$Plan {
  const factory Plan({
    String? id,
    String? title,
    @Default(0) double? monthlyPrice,
    @Default(0) double? yearlyPrice,
    @Default([]) List<PlanFeature> features,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}
