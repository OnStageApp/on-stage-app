import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/adaptive_duration_picker.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EditDuration extends StatefulWidget {
  const EditDuration({
    required this.selectedDuration,
    required this.onDurationChanged,
    super.key,
  });

  final Duration? selectedDuration;
  final void Function(Duration) onDurationChanged;

  @override
  State<EditDuration> createState() => EditDurationState();
}

class EditDurationState extends State<EditDuration> {
  final GlobalKey _timePickerKey = GlobalKey();
  Duration? _currentDuration;

  @override
  void initState() {
    super.initState();
    _currentDuration = widget.selectedDuration;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _timePickerKey,
      onTap: _showDurationPicker,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 16),
            Text(
              TimeUtils().formatDuration(_currentDuration),
              style: context.textTheme.titleMedium!.copyWith(
                color: _currentDuration != null
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.access_time,
                color: context.colorScheme.outline,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDurationPicker() async {
    final initialDuration = _currentDuration ?? Duration.zero;

    final result = await AdaptiveDurationPicker.show(
      context: context,
      initialDuration: initialDuration,
    );

    if (result != null) {
      setState(() => _currentDuration = result);
      widget.onDurationChanged(result);
    }
  }
}
