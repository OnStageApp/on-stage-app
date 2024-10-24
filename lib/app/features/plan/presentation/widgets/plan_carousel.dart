import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
import 'package:on_stage_app/app/features/plan/application/filtered_plans_provider.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_card.dart';

class PlanCarousel extends ConsumerWidget {
  const PlanCarousel({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlan = ref.watch(currentPlanProvider);

    final filteredPlans = ref.watch(filteredPlansProvider);

    return PageView.builder(
      controller: pageController,
      itemCount: filteredPlans.length,
      itemBuilder: (context, index) {
        final plan = filteredPlans[index];
        final isCurrent = currentPlan.entitlementId == plan.entitlementId &&
            currentPlan.isYearly == plan.isYearly;
        return PlanCard(plan: filteredPlans[index], isCurrent: isCurrent);
      },
    );
  }
}
