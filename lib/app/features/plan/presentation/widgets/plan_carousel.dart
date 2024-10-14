import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/plan/data/static_plans.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_card.dart';

class PlanCarousel extends StatelessWidget {
  final PageController pageController;

  const PlanCarousel({
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: plans.map((plan) {
        return PlanCard(plan: plan);
      }).toList(),
    );
  }
}
