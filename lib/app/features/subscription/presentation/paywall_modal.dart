import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PaywallModal extends ConsumerStatefulWidget {
  const PaywallModal({
    required this.permissionType,
    super.key,
  });

  final PermissionType permissionType;

  static void show({
    required BuildContext context,
    required PermissionType permissionType,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: PaywallModal(
            permissionType: permissionType,
          ),
        );
      },
    );
  }

  @override
  _PaywallModalState createState() => _PaywallModalState();
}

class _PaywallModalState extends ConsumerState<PaywallModal> {
  Plan? upgradePlan;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUpgradePlan();
    });
  }

  Future<void> _fetchUpgradePlan() async {
    final currentPlan = ref.read(currentPlanProvider);
    try {
      final result = await getUpgradePlan(ref, currentPlan);
      setState(() {
        upgradePlan = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load plan details';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding.copyWith(bottom: 32, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                context.popDialog();
              },
              child: Text(
                'Close',
                style: context.textTheme.titleLarge!
                    .copyWith(color: context.colorScheme.outline),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: Image.asset(
              'assets/images/onboarding_first_step.png',
              fit: BoxFit.contain,
            ),
          ),
          TitleWidget(
            title: widget.permissionType.title,
            subtitle: '${widget.permissionType.paywallDescription}\n '
                'Get ${upgradePlan?.name ?? 'N/A'} to unlock this feature.',
            subtitleFontSize: 18,
          ),
          const Spacer(),
          if (isLoading)
            const CircularProgressIndicator()
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                errorMessage!,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            )
          else if (upgradePlan != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ContinueButton(
                text: 'Get ${upgradePlan!.name}',
                isLoading: ref.watch(subscriptionNotifierProvider).isLoading,
                backgroundColor: context.isDarkMode
                    ? context.colorScheme.secondary
                    : context.colorScheme.onSecondary,
                textStyle: context.textTheme.titleLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
                onPressed: () async {
                  final subscriptionNotifier =
                      ref.read(subscriptionNotifierProvider.notifier);
                  await subscriptionNotifier
                      .purchasePackage(upgradePlan!.revenueCatProductId);
                },
                isEnabled: true,
              ),
            ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Auto-renews for ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: isLoading
                        ? '...'
                        : (upgradePlan != null
                            ? '${upgradePlan!.price} ${upgradePlan!.currency}/month'
                            : 'N/A'),
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: ' until canceled.',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Plan> getUpgradePlan(WidgetRef ref, Plan currentPlan) async {
    final allPlans =
        await ref.read(planServiceProvider.notifier).fetchAndSavePlans();

    if (currentPlan.entitlementId == 'starter') {
      return allPlans.firstWhere(
        (plan) => plan.entitlementId == 'pro' && !plan.isYearly,
      );
    } else {
      return allPlans.firstWhere(
        (plan) => plan.entitlementId == 'ultimate' && !plan.isYearly,
      );
    }
  }
}
