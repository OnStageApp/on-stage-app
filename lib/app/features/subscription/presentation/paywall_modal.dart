import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PaywallModal extends ConsumerWidget {
  const PaywallModal({
    required this.permissionType,
    super.key,
  });

  final PermissionType permissionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TitleWidget(
              title: 'Reminders',
              subtitle: 'Set reminders for you team! '
                  '\nGet Pro to unlock this feature.',
              subtitleFontSize: 18,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ContinueButton(
              text: 'Get Pro',
              isLoading: ref.watch(subscriptionNotifierProvider).isLoading,
              backgroundColor: context.colorScheme.secondary,
              textStyle: context.textTheme.titleLarge!.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
              onPressed: () async {
                final subscriptionNotifier =
                    ref.read(subscriptionNotifierProvider.notifier);
                await subscriptionNotifier.purchasePackage('starter');
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
                    text: '4.99 RON',
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: '/month until canceled.',
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
}
