import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CloseHeader extends StatelessWidget {
  const CloseHeader({
    required this.title,
    this.backgroundColor,
    this.onBackgroundColor,
    super.key,
    this.onClose,
  });
  static const double height = 16 + 24 + 16;

  final Color? backgroundColor;
  final Color? onBackgroundColor;
  final Widget title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.only(top: 8),
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.onBackground.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          title,
        ],
      ),
    );
  }
}
