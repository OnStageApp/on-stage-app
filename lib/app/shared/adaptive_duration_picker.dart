import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AdaptiveDurationPicker {
  static Future<Duration?> show({
    required BuildContext context,
    required Duration initialDuration,
  }) async {
    if (Platform.isIOS) {
      return _showCupertinoPicker(context, initialDuration);
    } else {
      return _showMaterialPicker(context, initialDuration);
    }
  }

  static Future<Duration?> _showCupertinoPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    Duration tempDuration = initialDuration;

    final result = await showCupertinoModalPopup<Duration?>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            initialTimerDuration: initialDuration,
                            onTimerDurationChanged: (Duration newDuration) {
                              tempDuration = newDuration;
                            },
                          ),
                        ),
                        const Divider(height: 0.5),
                        CupertinoButton(
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(tempDuration);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result;
  }

  static Future<Duration?> _showMaterialPicker(
    BuildContext context,
    Duration initialDuration,
  ) async {
    Duration? selectedDuration = initialDuration;

    return showDialog<Duration>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NumberPicker(
                    label: 'Hours',
                    value: initialDuration.inHours,
                    maxValue: 23,
                    onChanged: (value) {
                      selectedDuration = Duration(
                        hours: value,
                        minutes: selectedDuration?.inMinutes.remainder(60) ?? 0,
                      );
                    },
                  ),
                  const SizedBox(width: 32),
                  _NumberPicker(
                    label: 'Minutes',
                    value: initialDuration.inMinutes.remainder(60),
                    maxValue: 59,
                    onChanged: (value) {
                      selectedDuration = Duration(
                        hours: selectedDuration?.inHours ?? 0,
                        minutes: value,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, selectedDuration),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _NumberPicker({
    required String label,
    required int value,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          height: 180,
          width: 64,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                controller: FixedExtentScrollController(initialItem: value),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: maxValue + 1,
                  builder: (context, index) => Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: index == value
                                ? Colors.blue
                                : Colors.grey.shade600,
                          ),
                    ),
                  ),
                ),
                onSelectedItemChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
