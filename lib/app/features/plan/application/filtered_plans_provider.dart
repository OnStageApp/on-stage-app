import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller.dart';

final filteredPlansProvider = Provider<List<Plan>>((ref) {
  final isYearlyPlan =
      ref.watch(planControllerProvider.select((state) => state.isYearlyPlan));
  final plans = ref.watch(planServiceProvider.select((state) => state.plans));

  final excludedEntitlements = {'pro', 'solo', 'ultimate'};

  return plans.where((plan) {
    final hasValidProductId = Platform.isAndroid
        ? plan.googleProductId.isNotEmpty
        : plan.appleProductId.isNotEmpty;

    return hasValidProductId &&
        !excludedEntitlements.contains(plan.entitlementId) &&
        (plan.entitlementId == 'starter' || plan.isYearly == isYearlyPlan);
  }).toList();
});
