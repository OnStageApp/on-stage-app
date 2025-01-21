import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class FloatingModal extends StatelessWidget {
  const FloatingModal({
    required this.child,
    required this.backgroundColor,
    super.key,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

class AdaptiveModal {
  static const double kMinWidth = 400;
  static const double kMaxWidth = 700;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool expand = true,
    bool useRootNavigator = true,
    bool isFloatingForLargeScreens = false,
    Color? backgroundColor,
  }) async {
    if (isFloatingForLargeScreens && context.isLargeScreen) {
      return showCustomModalBottomSheet(
        context: context,
        builder: (context) => child,
        containerWidget: (_, animation, child) => Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: kMaxWidth,
              minWidth: kMinWidth,
            ),
            child: FloatingModal(
              backgroundColor: backgroundColor ?? context.colorScheme.surface,
              child: child,
            ),
          ),
        ),
      );
    }
    if (Platform.isIOS) {
      return showCupertinoModalBottomSheet<T>(
        context: context,
        useRootNavigator: !context.isLargeScreen && useRootNavigator,
        backgroundColor: backgroundColor,
        expand: expand,
        builder: (context) => Material(
          child: child,
        ),
      );
    } else {
      return showMaterialModalBottomSheet<T>(
        useRootNavigator: !context.isLargeScreen && useRootNavigator,
        context: context,
        backgroundColor: backgroundColor,
        expand: expand,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.95,
          child: Material(child: child),
        ),
      );
    }
  }
}
