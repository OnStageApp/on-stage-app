import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/dialog_helper.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission({
  required BuildContext context,
  required Permission permission,
  required void Function() onSettingsOpen,
}) async {
  final status = await permission.status;



  if (status.isDenied || status.isPermanentlyDenied) {
    final bool shouldShowDialog;
    if (status.isDenied) {
      shouldShowDialog = (await permission.request()).isDenied;
    } else {
      shouldShowDialog = true;
    }

    if (shouldShowDialog) {
      await DialogHelper.showPlatformDialog(
        context: context,
        title: const Text('Notification Permission'),
        content: const Text(
          'Please enable notification permissions in settings.',
        ),
        confirmText: 'Open Settings',
        cancelText: 'Cancel',
        isDestructive: true,
        onConfirm: onSettingsOpen,
      );
    } else {
      debugPrint('Permission granted after request');
    }
  } else {
    debugPrint('Unhandled permission status: $status');
  }
}

Future<void> openSettings(BuildContext context) async {
  final success = await openAppSettings();
  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open app settings. Please try again.'),
      ),
    );
  }
}

