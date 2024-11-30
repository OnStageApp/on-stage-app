import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool?> showPlatformDialog({
    required BuildContext context,
    required Widget title,
    required Widget content,
    String? cancelText,
    String? confirmText,
    bool isDestructive = false,
    VoidCallback? onConfirm,
  }) {
    if (Platform.isAndroid) {
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(cancelText ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                child: Text(confirmText ?? 'Confirm'),
              ),
            ],
          );
        },
      );
    } else {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: [
              CupertinoDialogAction(
                child: Text(cancelText ?? 'Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                isDestructiveAction: isDestructive,
                child: Text(confirmText ?? 'Confirm'),
              ),
            ],
          );
        },
      );
    }
  }
}
