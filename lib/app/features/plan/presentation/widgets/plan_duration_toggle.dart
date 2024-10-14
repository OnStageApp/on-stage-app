import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/toggle_background_painter.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PlanDurationToggle extends ConsumerStatefulWidget {
  const PlanDurationToggle({required this.onToggle, super.key});

  final void Function() onToggle;

  @override
  ConsumerState<PlanDurationToggle> createState() => _PlanDurationToggleState();
}

class _PlanDurationToggleState extends ConsumerState<PlanDurationToggle> {
  @override
  Widget build(BuildContext context) {
    final isYearly = ref.watch(planControllerProvider).isYearlyPlan;
    return Center(
      child: SizedBox(
        width: 240,
        height: 40,
        child: CustomPaint(
          painter: ToggleBackgroundPainter(
            isSelected: isYearly,
            context: context,
          ),
          child: Row(
            children: [
              _buildOption('Monthly', '', !isYearly),
              _buildOption('Yearly ', '15% off', isYearly),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String text, String extraText, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onToggle();
        },
        child: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: text,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
                ),
                TextSpan(
                  text: extraText,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
