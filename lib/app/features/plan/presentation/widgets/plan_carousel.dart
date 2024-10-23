import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_card.dart';

class PlanCarousel extends ConsumerWidget {
  const PlanCarousel({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isYearlyPlan = ref.watch(planControllerProvider).isYearlyPlan;
    final plans = ref.watch(planServiceProvider).plans;
    final filteredPlans = [
      ...plans.where((plan) => plan.isYearly == isYearlyPlan),
    ];

    return PageView.builder(
      controller: pageController,
      itemCount: filteredPlans.length,
      itemBuilder: (context, index) {
        return PlanCard(plan: filteredPlans[index]);
      },
    );
  }
}
