import 'dart:io';

import 'package:flutter/gestures.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: context.isDarkMode
          ? context.colorScheme.surface
          : context.colorScheme.onSurfaceVariant,
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
    return Container(
      padding: defaultScreenPadding.copyWith(bottom: 32, top: 16),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? context.colorScheme.surface
            : context.colorScheme.surface,
        gradient: LinearGradient(
          stops: const [0.0, 0.7],
          colors: context.isDarkMode
              ? [
                  const Color(0x1A1996FF),
                  const Color(0x001A1C1E),
                ]
              : [
                  const Color(0x1A1996FF),
                  const Color(0x001A1C1E),
                ],
          begin: Alignment.topRight,
          end: Alignment.center,
        ),
      ),
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
            height: 350,
            child: Image.asset(
              widget.permissionType
                  .paywallImage(isDarkMode: context.isDarkMode),
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          TitleWidget(
            title: widget.permissionType.title,
            subtitle: '${widget.permissionType.paywallDescription}\n '
                'Get ${upgradePlan?.entitlementId.toUpperCase() ?? 'N/A'} Plan '
                'to unlock this feature.',
            subtitleFontSize: 18,
          ),
          const SizedBox(height: 48),
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
                text: 'Try Free for 30-days',
                isLoading: ref.watch(subscriptionNotifierProvider).isLoading,
                borderColor: context.colorScheme.primary,
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
                  if (Platform.isIOS) {
                    await subscriptionNotifier
                        .purchasePackage(upgradePlan!.appleProductId);
                  } else {
                    await subscriptionNotifier
                        .purchasePackage(upgradePlan!.googleProductId);
                  }

                  if (mounted) {
                    context.popDialog();
                  }
                },
                isEnabled: true,
              ),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Auto-renews for ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: isLoading
                        ? 'Loading'
                        : (upgradePlan != null
                            ? '${upgradePlan!.price} ${upgradePlan!.currency}/month '
                            : 'N/A'),
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'unitl canceled.',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cancel any time '
                        'in the App Store '
                        'at no additional cost. ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: 'terms. ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.primary,
                      fontSize: 11,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        openUrl(
                          'https://philosophical-stage-226575.framer.app/terms',
                        );
                      },
                  ),
                  TextSpan(
                    text: 'See the ',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: 'privacy policy.',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.primary,
                      fontSize: 11,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        openUrl(
                          'https://philosophical-stage-226575.framer.app/privacy',
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in browser
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<Plan> getUpgradePlan(WidgetRef ref, Plan currentPlan) async {
    final allPlans = ref.watch(planServiceProvider).plans;
    final memberTiers = [
      'starter',
      '20members',
      '50members',
      '150members',
      '400members',
      '1000members',
    ];

    final currentTierIndex = memberTiers.indexOf(currentPlan.entitlementId);
    if (currentTierIndex == -1 || currentTierIndex == memberTiers.length - 1) {
      throw Exception('No upgrade available');
    }

    final nextTier = memberTiers[currentTierIndex + 1];

    return allPlans.firstWhere(
      (plan) =>
          plan.entitlementId == nextTier &&
          plan.isYearly == currentPlan.isYearly,
      orElse: () => throw Exception('Upgrade plan not found'),
    );
  }
}
