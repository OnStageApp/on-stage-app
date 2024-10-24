import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/utils/permission/permission_checker.dart';
import 'package:on_stage_app/app/utils/permission/permission_notifier.dart';

Future<void> handlePermission({
  required BuildContext context,
  required WidgetRef ref,
  required PermissionType permissionType,
  required VoidCallback onGranted,
}) async {
  final permissionChecker = ref.read(localPermissionCheckerProvider);

  if (permissionChecker.checkPermission(permissionType)) {
    onGranted();
  } else {
    ref
        .read(permissionNotifierProvider.notifier)
        .permissionDenied(permissionType);
  }
}
