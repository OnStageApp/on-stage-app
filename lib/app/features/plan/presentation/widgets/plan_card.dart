import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/plan/domain/plan_feature.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
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
    ref.listen(
      subscriptionNotifierProvider.select((state) => state.isLoading),
      (previous, isLoading) {
        if (isLoading) {
          showLoadingOverlay(context);
        } else {
          Navigator.of(context).pop(); // Remove loading overlay
        }
      },
    );
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
                  '${plan.name} Members',
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
                ),
                if (plan.name == '50')
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
                      ? '${(plan.price / 12).toStringAsFixed(0)} RON/month'
                      : '${plan.price} ${plan.currency}/month',
              style: context.textTheme.headlineMedium!.copyWith(
                color: context.colorScheme.onSecondary,
              ),
            ),
            if (plan.isYearly)
              Text(
                '${plan.price} ${plan.currency}/year',
                style: context.textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.outline,
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
                text: isCurrent ? 'Current Plan ' : 'Try for Free',
                textColor: isCurrent
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onSurfaceVariant,
                backgroundColor: isCurrent
                    ? context.colorScheme.surface
                    : context.colorScheme.onSecondary,
                borderColor: context.colorScheme.primaryContainer,
                onPressed: () {
                  if (!isCurrent) _handlePurchase(ref, context);
                },
                isEnabled: true,
                hasShadow: false,
              ),
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
    BuildContext context,
  ) async {
    final subscriptionNotifier =
        ref.read(subscriptionNotifierProvider.notifier);
    if (Platform.isAndroid) {
      await subscriptionNotifier.purchasePackage(plan.googleProductId);
    } else {
      await subscriptionNotifier.purchasePackage(plan.appleProductId);
    }
    if (context.mounted) {
      context.pop();
    }
  }

  void showLoadingOverlay(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: const Center(
          child: SizedBox(
            height: 32,
            width: 32,
            child: LoadingIndicator(
              colors: [Colors.white],
              indicatorType: Indicator.lineSpinFadeLoader,
            ),
          ),
        ),
      ),
    );
  }
}
