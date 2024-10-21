import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/user/application/check_permission_provider.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

Future<void> doActionWithPermissionCheck({
  required BuildContext context,
  required WidgetRef ref,
  required PermissionType permissionType,
  required VoidCallback onGranted,
  required String deniedMessage,
}) async {
  final hasPermission =
      await ref.read(checkPermissionProvider(permissionType.name).future);

  if (hasPermission) {
    onGranted();
  } else {
    PaywallModal.show(
      context: context,
      ref: ref,
      onGetSubscription: () async {
        final subscriptionNotifier =
            ref.read(subscriptionNotifierProvider.notifier);

        await subscriptionNotifier.purchasePackage('starter');
      },
      onLearnMore: () {},
    );
  }
}
