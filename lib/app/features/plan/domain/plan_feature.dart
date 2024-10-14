import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_feature.freezed.dart';
part 'plan_feature.g.dart';

@Freezed()
class PlanFeature with _$PlanFeature {
  const factory PlanFeature({
    required String name,
    required bool isAvailable,
  }) = _PlanFeature;

  factory PlanFeature.fromJson(Map<String, dynamic> json) =>
      _$PlanFeatureFromJson(json);
}
