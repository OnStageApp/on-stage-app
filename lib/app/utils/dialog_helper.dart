import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool?> showPlatformDialog({
    required BuildContext context,
    required Widget title,
    required Widget content,
    String? cancelText,
    Color? cancelTextColor,
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
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(cancelText),
                ),
              if (confirmText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
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
              if (cancelText != null)
                CupertinoDialogAction(
                  child: Text(cancelText),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              if (confirmText != null)
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                  isDestructiveAction: isDestructive,
                  child: Text(
                    confirmText,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          );
        },
      );
    }
  }
}
