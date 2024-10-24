import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/plan/domain/plan_feature.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PlanCard extends ConsumerWidget {
  const PlanCard({
    required this.plan,
    required this.isCurrent,
    super.key,
  });

  final Plan plan;
  final bool isCurrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: context.colorScheme.onSurfaceVariant,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.primaryContainer,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
                ),
                if (plan.name == 'Pro')
                  Container(
                    padding: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.blue[100]!, Colors.blue[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.1, 0.6],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: Colors.blue[500],
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Most Popular',
                          style: context.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              plan.price == 0
                  ? 'Free'
                  : plan.isYearly
                      ? '${plan.price.toInt()} ${plan.currency}/month, billed annually'
                      : '${plan.price.toInt()} ${plan.currency}/month',
              style: context.textTheme.headlineMedium!.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            ),
            const SizedBox(height: 20),
            DashedLineDivider(
              color: context.colorScheme.primaryContainer,
            ),
            const SizedBox(height: 20),
            ...plan.features.map(
              (feature) => _buildFeatureItem(context, feature),
            ),
            const Spacer(),
            if (plan.price != 0)
              ContinueButton(
                isLoading: ref.watch(subscriptionNotifierProvider).isLoading,
                text: isCurrent ? 'Current Plan ' : 'Upgrade',
                textColor: isCurrent
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onSurfaceVariant,
                backgroundColor: isCurrent
                    ? context.colorScheme.surface
                    : context.colorScheme.onSecondary,
                borderColor: context.colorScheme.primaryContainer,
                onPressed: () {
                  if (!isCurrent) _handlePurchase(ref);
                },
                isEnabled: true,
                hasShadow: false,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, PlanFeature feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            feature.isAvailable ? Icons.check : Icons.close,
            color: feature.isAvailable ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium!.copyWith(
                color: feature.isAvailable
                    ? context.colorScheme.onSurface
                    : context.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(
    WidgetRef ref,
  ) async {
    final subscriptionNotifier =
        ref.read(subscriptionNotifierProvider.notifier);

    await subscriptionNotifier.purchasePackage(plan.revenueCatProductId);
  }
}

//TODO: Plans on annual and month are different so it will be displayed differently.. check and FIX THIS
