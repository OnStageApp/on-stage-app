import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StageToggle extends ConsumerWidget {
  const StageToggle({
    required this.initialIndex,
    required this.labels,
    required this.onToggle,
    required this.totalSwitches,
    super.key,
    this.borderWidth = 5,
    this.fontSize = 16,
    this.minHeight = 38,
    this.minWidth = double.infinity,
  });

  final int initialIndex;
  final List<String> labels;
  final void Function(int?) onToggle;
  final double borderWidth;
  final double fontSize;
  final double minHeight;
  final double minWidth;
  final int totalSwitches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ToggleSwitch(
          initialLabelIndex: initialIndex,
          borderWidth: borderWidth,
          activeFgColor: context.colorScheme.onSurfaceVariant,
          fontSize: fontSize,
          inactiveFgColor: context.colorScheme.onSurface,
          activeBgColor: [context.colorScheme.primary],
          inactiveBgColor: context.colorScheme.onSurfaceVariant,
          minWidth: minWidth,
          minHeight: minHeight,
          cornerRadius: 10,
          totalSwitches: totalSwitches,
          radiusStyle: true,
          labels: labels,
          onToggle: onToggle,
        ),
      ),
    );
  }
}
