import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';

final currentPlanProvider = Provider<Plan>((ref) {
  final plans = ref.watch(planServiceProvider).plans;
  final currentPlanId = ref.watch(
    subscriptionNotifierProvider.select(
      (state) => state.currentSubscription?.planId,
    ),
  );

  if (plans.isEmpty) {
    throw StateError('No plans available');
  }

  final starterPlan = plans.firstWhere(
    (plan) => plan.entitlementId == 'starter',
  );

  if (currentPlanId == null) return starterPlan;

  return plans.firstWhere(
    (p) => p.id == currentPlanId,
    orElse: () => starterPlan,
  );
});
