import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/adaptive_duration_picker.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventItemTime extends StatelessWidget {
  const EventItemTime({
    required this.canEdit,
    required this.currentDuration,
    required this.eventStartDate,
    required this.cumulatedDuration,
    required this.onDurationChanged,
    super.key,
  });

  final bool canEdit;
  final Duration? currentDuration;
  final DateTime? eventStartDate;
  final Duration cumulatedDuration;
  final Future<void> Function(Duration?) onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          overlayColor: WidgetStateProperty.all(
            context.colorScheme.surfaceBright,
          ),
          borderRadius: BorderRadius.circular(20),
          onTap: canEdit ? () => _showDurationPicker(context) : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: canEdit
                  ? Border.all(color: context.colorScheme.outline)
                  : const Border(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              TimeUtils().calculateTime(eventStartDate, cumulatedDuration),
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDurationPicker(BuildContext context) async {
    final duration = await AdaptiveDurationPicker.show(
      context: context,
      initialDuration: currentDuration ?? Duration.zero,
    );
    await onDurationChanged(duration);
  }
}
