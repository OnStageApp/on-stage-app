import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PaywallModal extends ConsumerWidget {
  const PaywallModal({
    required this.onGetSubscription,
    required this.onLearnMore,
    Key? key,
  }) : super(key: key);

  final void Function() onGetSubscription;
  final void Function() onLearnMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: defaultScreenPadding.copyWith(bottom: 64, top: 16),
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
          ContinueButton(
            text: 'Get Pro',
            isLoading: ref.watch(subscriptionNotifierProvider).isLoading,
            backgroundColor: context.colorScheme.secondary,
            onPressed: onGetSubscription,
            isEnabled: true,
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: onLearnMore,
            child: Text(
              'Learn More',
              style: context.textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }

  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required void Function() onGetSubscription,
    required void Function() onLearnMore,
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
          heightFactor: 0.9,
          child: PaywallModal(
            onGetSubscription: onGetSubscription,
            onLearnMore: onLearnMore,
          ),
        );
      },
    );
  }
}
