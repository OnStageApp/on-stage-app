import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/plan/domain/plan_feature.dart';

const List<Plan> plans = [
  Plan(
    id: '1',
    title: 'Starter',
    monthlyPrice: 0,
    yearlyPrice: 0,
    features: [
      PlanFeature(name: 'Max 1 member in Team', isAvailable: true),
      PlanFeature(name: 'Max 3 events', isAvailable: true),
      PlanFeature(name: 'Add max 30 songs', isAvailable: true),
    ],
  ),
  Plan(
    id: '1',
    title: 'Solo',
    monthlyPrice: 6,
    yearlyPrice: 60,
    features: [
      PlanFeature(name: 'Max 10 members in Team', isAvailable: true),
      PlanFeature(name: 'Unlimited Events', isAvailable: true),
      PlanFeature(name: 'Full access to Songs', isAvailable: true),
      PlanFeature(name: 'Real time sync between screens', isAvailable: false),
      PlanFeature(name: 'Event reminders', isAvailable: false),
    ],
  ),
  Plan(
    id: '2',
    title: 'Pro',
    monthlyPrice: 12,
    yearlyPrice: 120,
    features: [
      PlanFeature(name: 'Max 10 members in Team', isAvailable: true),
      PlanFeature(name: 'Unlimited Events', isAvailable: true),
      PlanFeature(name: 'Full access to Songs', isAvailable: true),
      PlanFeature(name: 'Add your own song', isAvailable: true),
      PlanFeature(name: 'Real time sync between screens', isAvailable: true),
      PlanFeature(name: 'Event reminders', isAvailable: true),
    ],
  ),
  Plan(
    id: '3',
    title: 'Ultimate',
    monthlyPrice: 16,
    yearlyPrice: 160,
    features: [
      PlanFeature(name: 'Max 10 members in Team', isAvailable: true),
      PlanFeature(name: 'Unlimited Events', isAvailable: true),
      PlanFeature(name: 'Full access to Songs', isAvailable: true),
      PlanFeature(name: 'Add your own song', isAvailable: true),
      PlanFeature(name: 'Real time sync between screens', isAvailable: true),
      PlanFeature(name: 'Event reminders', isAvailable: true),
    ],
  ),
];
