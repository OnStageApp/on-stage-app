// lib/app/common/permission/handle_permission.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

import 'permission_checker.dart';

Future<void> handlePermission({
  required BuildContext context,
  required WidgetRef ref,
  required PermissionType permissionType,
  required VoidCallback onGranted,
  VoidCallback? onDenied,
}) async {
  final permissionChecker = PermissionChecker(ref);

  if (permissionChecker.checkPermission(permissionType)) {
    onGranted();
  } else {
    if (onDenied != null) {
      onDenied();
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
}
